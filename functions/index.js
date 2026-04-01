const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();

// ─── Booster rarity probabilities ──────────────────────────────────────────
const RARITY_RATES = {
  commune: 0.60,
  rare: 0.25,
  epique: 0.12,
  legendaire: 0.03,
};

function drawRarity() {
  const roll = Math.random();
  let cumulative = 0;
  for (const [rarity, rate] of Object.entries(RARITY_RATES)) {
    cumulative += rate;
    if (roll <= cumulative) return rarity;
  }
  return 'commune';
}

// ─── Validate duel result and distribute rewards ────────────────────────────
exports.validateDuelResult = functions.firestore
  .document('duels/{duelId}')
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();

    // Only process when both players have submitted answers
    if (
      before.status === after.status ||
      after.status !== 'completed'
    ) return null;

    const { duelId } = context.params;
    const initiatorScore = after.initiatorScore || 0;
    const opponentScore = after.opponentScore || 0;

    let winnerId = null;
    if (initiatorScore > opponentScore) {
      winnerId = after.initiatorUserId;
    } else if (opponentScore > initiatorScore) {
      winnerId = after.opponentUserId;
    }

    const batch = db.batch();

    // Update duel with winner
    batch.update(change.after.ref, { winnerId, resolvedAt: admin.firestore.FieldValue.serverTimestamp() });

    // Distribute XP & coins
    const winnerXp = 100;
    const loserXp = 30;
    const winnerCoins = 50;
    const loserCoins = 10;

    const updateUser = (userId, xp, coins) => {
      const userRef = db.doc(`users/${userId}`);
      batch.update(userRef, {
        'stats.totalDuels': admin.firestore.FieldValue.increment(1),
        'stats.duelWins': admin.firestore.FieldValue.increment(userId === winnerId ? 1 : 0),
        xp: admin.firestore.FieldValue.increment(xp),
        coins: admin.firestore.FieldValue.increment(coins),
      });
    };

    updateUser(after.initiatorUserId, initiatorScore >= opponentScore ? winnerXp : loserXp, initiatorScore >= opponentScore ? winnerCoins : loserCoins);
    updateUser(after.opponentUserId, opponentScore >= initiatorScore ? winnerXp : loserXp, opponentScore >= initiatorScore ? winnerCoins : loserCoins);

    await batch.commit();
    functions.logger.info(`Duel ${duelId} resolved. Winner: ${winnerId}`);
    return null;
  });

// ─── Generate daily challenge at 6AM Paris time ────────────────────────────
exports.generateDailyChallenge = functions.pubsub
  .schedule('0 6 * * *')
  .timeZone('Europe/Paris')
  .onRun(async () => {
    const today = new Date().toISOString().split('T')[0]; // YYYY-MM-DD

    // Pick a random pack
    const packsSnap = await db.collection('packs').where('isActive', '==', true).get();
    if (packsSnap.empty) return null;

    const packs = packsSnap.docs;
    const randomPack = packs[Math.floor(Math.random() * packs.length)];

    // Pick 5 random questions from that pack
    const questionsSnap = await db
      .collection('packs')
      .doc(randomPack.id)
      .collection('questions')
      .where('isActive', '==', true)
      .limit(20)
      .get();

    if (questionsSnap.empty) return null;

    const allQuestions = questionsSnap.docs.map((d) => d.id);
    const shuffled = allQuestions.sort(() => 0.5 - Math.random());
    const selected = shuffled.slice(0, Math.min(5, shuffled.length));

    await db.collection('dailyChallenges').doc(today).set({
      date: today,
      packId: randomPack.id,
      packTitle: randomPack.data().title,
      questionIds: selected,
      bonusCoins: 30,
      bonusXp: 150,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    functions.logger.info(`Daily challenge generated for ${today}`);
    return null;
  });

// ─── Validate IAP purchase ──────────────────────────────────────────────────
exports.validatePurchase = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated.');
  }

  const { productId, purchaseToken, platform } = data;
  if (!productId || !purchaseToken || !platform) {
    throw new functions.https.HttpsError('invalid-argument', 'Missing required fields.');
  }

  // TODO: Implement actual receipt validation with Apple/Google APIs
  // For now, grant subscription based on productId
  const userId = context.auth.uid;

  const validProducts = ['app_rap_monthly', 'app_rap_yearly'];
  if (!validProducts.includes(productId)) {
    throw new functions.https.HttpsError('invalid-argument', 'Unknown product.');
  }

  const expiryDate = new Date();
  expiryDate.setMonth(expiryDate.getMonth() + (productId.includes('yearly') ? 12 : 1));

  await db.doc(`users/${userId}`).update({
    isPremium: true,
    premiumUntil: admin.firestore.Timestamp.fromDate(expiryDate),
    'stats.lastPurchase': admin.firestore.FieldValue.serverTimestamp(),
  });

  // Log transaction
  await db.collection('transactions').add({
    userId,
    productId,
    platform,
    purchaseToken,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    type: 'subscription',
  });

  return { success: true, expiryDate: expiryDate.toISOString() };
});

// ─── Open booster - server-side card draw ──────────────────────────────────
exports.openBooster = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated.');
  }

  const userId = context.auth.uid;
  const { boosterId } = data;

  const userRef = db.doc(`users/${userId}`);
  const userSnap = await userRef.get();
  if (!userSnap.exists) {
    throw new functions.https.HttpsError('not-found', 'User not found.');
  }

  const userData = userSnap.data();
  const boosterCost = 100; // coins

  if ((userData.coins || 0) < boosterCost) {
    throw new functions.https.HttpsError('failed-precondition', 'Insufficient coins.');
  }

  // Draw 3 cards
  const drawnRarities = [drawRarity(), drawRarity(), drawRarity()];
  const drawnCards = [];

  for (const rarity of drawnRarities) {
    const cardsSnap = await db
      .collection('cards')
      .where('rarity', '==', rarity)
      .get();

    if (!cardsSnap.empty) {
      const available = cardsSnap.docs;
      const picked = available[Math.floor(Math.random() * available.length)];
      drawnCards.push({ id: picked.id, ...picked.data() });
    }
  }

  const batch = db.batch();

  // Deduct coins
  batch.update(userRef, {
    coins: admin.firestore.FieldValue.increment(-boosterCost),
  });

  // Add cards to user collection
  for (const card of drawnCards) {
    const cardRef = userRef.collection('cards').doc(card.id);
    const existingCard = await cardRef.get();
    if (existingCard.exists) {
      batch.update(cardRef, { count: admin.firestore.FieldValue.increment(1) });
    } else {
      batch.set(cardRef, {
        cardId: card.id,
        rarity: card.rarity,
        artistName: card.artistName,
        title: card.title,
        count: 1,
        obtainedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }
  }

  // Log booster opening
  batch.set(db.collection('boosters').doc(), {
    userId,
    cardsObtained: drawnCards.map((c) => c.id),
    cost: boosterCost,
    openedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  await batch.commit();

  return { success: true, cards: drawnCards };
});
