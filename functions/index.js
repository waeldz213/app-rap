const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

const db = admin.firestore();

// Validate duel result and award prizes
exports.validateDuelResult = functions.firestore
  .document('duels/{duelId}')
  .onUpdate(async (change, context) => {
    const duel = change.after.data();
    if (duel.status !== 'completed' || duel.rewardsDistributed) return null;

    const { duelId } = context.params;
    const { winnerId, initiatorUserId, opponentUserId, initiatorScore, opponentScore } = duel;

    const batch = db.batch();
    const winnerRef = db.collection('users').doc(winnerId);
    const loserId = winnerId === initiatorUserId ? opponentUserId : initiatorUserId;
    const loserRef = db.collection('users').doc(loserId);

    batch.update(winnerRef, {
      coins: admin.firestore.FieldValue.increment(50),
      xp: admin.firestore.FieldValue.increment(100),
      rankPoints: admin.firestore.FieldValue.increment(30),
      'stats.totalDuelWins': admin.firestore.FieldValue.increment(1),
      'stats.totalDuelsPlayed': admin.firestore.FieldValue.increment(1),
    });

    batch.update(loserRef, {
      coins: admin.firestore.FieldValue.increment(10),
      xp: admin.firestore.FieldValue.increment(25),
      rankPoints: admin.firestore.FieldValue.increment(-15),
      'stats.totalDuelLosses': admin.firestore.FieldValue.increment(1),
      'stats.totalDuelsPlayed': admin.firestore.FieldValue.increment(1),
    });

    batch.update(db.collection('duels').doc(duelId), {
      rewardsDistributed: true,
    });

    await batch.commit();
    return null;
  });

// Generate daily challenge
exports.generateDailyChallenge = functions.pubsub
  .schedule('0 0 * * *')
  .timeZone('Europe/Paris')
  .onRun(async () => {
    const today = new Date().toISOString().split('T')[0];

    const questionsSnapshot = await db.collection('questions')
      .where('isActive', '==', true)
      .limit(100)
      .get();

    const questions = questionsSnapshot.docs.map(doc => doc.id);
    const shuffled = questions.sort(() => Math.random() - 0.5);
    const selectedIds = shuffled.slice(0, 10);

    await db.collection('dailyChallenges').doc(today).set({
      id: today,
      date: today,
      questionIds: selectedIds,
      completedByUserIds: [],
      rewards: {
        coins: 25,
        xp: 50,
        boosterChance: 0.30,
      },
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return null;
  });

// Validate in-app purchase
exports.validatePurchase = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { productId, purchaseToken, platform } = data;
  const userId = context.auth.uid;

  // TODO: Implement real purchase validation with Google Play / App Store APIs
  functions.logger.info(`Purchase validation requested for user ${userId}, product ${productId}`);

  if (productId === 'premium_monthly' || productId === 'premium_annual') {
    const expiresAt = new Date();
    if (productId === 'premium_monthly') {
      expiresAt.setMonth(expiresAt.getMonth() + 1);
    } else {
      expiresAt.setFullYear(expiresAt.getFullYear() + 1);
    }

    await db.collection('users').doc(userId).update({
      isPremium: true,
      premiumExpiresAt: admin.firestore.Timestamp.fromDate(expiresAt),
    });

    return { success: true, expiresAt: expiresAt.toISOString() };
  }

  return { success: false, error: 'Unknown product' };
});

// Open booster pack
exports.openBooster = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const userId = context.auth.uid;
  const { packId } = data;

  const rates = { commune: 0.60, rare: 0.25, epic: 0.12, legendary: 0.03 };

  const pickRarity = () => {
    const roll = Math.random();
    if (roll < rates.legendary) return 'legendary';
    if (roll < rates.legendary + rates.epic) return 'epic';
    if (roll < rates.legendary + rates.epic + rates.rare) return 'rare';
    return 'commune';
  };

  const cardIds = [];
  for (let i = 0; i < 3; i++) {
    const rarity = pickRarity();
    const cardsSnapshot = await db.collection('cards')
      .where('rarity', '==', rarity)
      .where('packId', '==', packId)
      .limit(20)
      .get();

    if (!cardsSnapshot.empty) {
      const cards = cardsSnapshot.docs;
      const randomCard = cards[Math.floor(Math.random() * cards.length)];
      cardIds.push(randomCard.id);

      await db.collection('userCards').add({
        userId,
        cardId: randomCard.id,
        acquiredAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }
  }

  await db.collection('boosters').add({
    userId,
    packId,
    cardIds,
    openedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  return { success: true, cardIds };
});
