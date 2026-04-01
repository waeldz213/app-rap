import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/card_model.dart';
import '../config/constants.dart';

class CollectionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CardModel>> getUserCards(String userId) async {
    final snap = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection(AppConstants.cardsCollection)
        .get();

    final futures = snap.docs.map((userCard) async {
      final cardId = userCard.data()['cardId'] as String? ?? userCard.id;
      final cardDoc = await _firestore
          .collection(AppConstants.cardsCollection)
          .doc(cardId)
          .get();

      if (!cardDoc.exists) return null;

      final cardData = cardDoc.data()!;
      return CardModel.fromJson({
        ...cardData,
        'count': userCard.data()['count'] ?? 1,
        'obtainedAt': userCard.data()['obtainedAt'],
      }, cardId);
    });

    final cards = await Future.wait(futures);
    return cards.whereType<CardModel>().toList();
  }

  Future<CardModel?> getCardById(String cardId) async {
    final doc = await _firestore
        .collection(AppConstants.cardsCollection)
        .doc(cardId)
        .get();

    if (!doc.exists) return null;
    return CardModel.fromJson(doc.data()!, doc.id);
  }

  /// Seed initial cards catalog
  Future<void> seedCards() async {
    final cards = _getSeedCards();
    final batch = _firestore.batch();

    for (final card in cards) {
      final ref =
          _firestore.collection(AppConstants.cardsCollection).doc(card.id);
      batch.set(ref, card.toJson(), SetOptions(merge: true));
    }

    await batch.commit();
  }

  List<CardModel> _getSeedCards() {
    return [
      // Communes (60%)
      CardModel(
        id: 'card_jul_flow',
        artistName: 'Jul',
        rarity: CardRarity.commune,
        title: 'Le Flow du Sud',
        flavorText: "L'incontournable du sud, prolifique et attachant.",
        bonusType: 'score_boost',
        bonusValue: 0.05,
      ),
      CardModel(
        id: 'card_ninho_roi',
        artistName: 'Ninho',
        rarity: CardRarity.commune,
        title: 'Le Roi du Mélo',
        flavorText: 'Mélodies accrocheuses et authenticité.',
        bonusType: 'score_boost',
        bonusValue: 0.05,
      ),
      CardModel(
        id: 'card_sch_archi',
        artistName: 'SCH',
        rarity: CardRarity.commune,
        title: "L'Architecte",
        flavorText: 'Constructeur de sonorités froides et tranchantes.',
        bonusType: 'score_boost',
        bonusValue: 0.05,
      ),
      // Rares (25%)
      CardModel(
        id: 'card_pnl_chico',
        artistName: 'PNL',
        rarity: CardRarity.rare,
        title: 'Le Monde Chico Era',
        flavorText: "L'ascension des frères de Tarterêts.",
        bonusType: 'score_boost',
        bonusValue: 0.08,
      ),
      CardModel(
        id: 'card_booba_temps_mort',
        artistName: 'Booba',
        rarity: CardRarity.rare,
        title: 'Temps Mort Era',
        flavorText: "L'album qui a tout changé.",
        bonusType: 'score_boost',
        bonusValue: 0.08,
      ),
      CardModel(
        id: 'card_sefyu_molotov',
        artistName: 'Sefyu',
        rarity: CardRarity.rare,
        title: 'Molotov Era',
        flavorText: 'Le lyriciste du 93 dans toute sa splendeur.',
        bonusType: 'score_boost',
        bonusValue: 0.08,
      ),
      // Épiques (12%)
      CardModel(
        id: 'card_nekfeu_alpha',
        artistName: 'Nekfeu & Alpha Wann',
        rarity: CardRarity.epique,
        title: 'Feat Légendaire',
        flavorText: 'Quand deux génies se rencontrent.',
        bonusType: 'score_boost',
        bonusValue: 0.10,
      ),
      CardModel(
        id: 'card_ntm_supr',
        artistName: 'Suprême NTM',
        rarity: CardRarity.epique,
        title: 'Album Culte',
        flavorText: 'Les pères fondateurs du rap FR.',
        bonusType: 'score_boost',
        bonusValue: 0.10,
      ),
      // Légendaires (3%)
      CardModel(
        id: 'card_booba_duc',
        artistName: 'Booba',
        rarity: CardRarity.legendaire,
        title: 'Le Duc Ultime',
        flavorText: 'Le règne incontesté du Duc de Boulogne.',
        bonusType: 'score_boost',
        bonusValue: 0.15,
      ),
      CardModel(
        id: 'card_iam_ecole',
        artistName: 'IAM',
        rarity: CardRarity.legendaire,
        title: "L'École du Micro d'Argent",
        flavorText: "L'album fondateur de la scène marseillaise.",
        bonusType: 'score_boost',
        bonusValue: 0.15,
      ),
      CardModel(
        id: 'card_oxmo_poete',
        artistName: 'Oxmo Puccino',
        rarity: CardRarity.legendaire,
        title: 'Le Poète',
        flavorText: 'Le Shakespeare du rap français.',
        bonusType: 'score_boost',
        bonusValue: 0.15,
      ),
    ];
  }
}

  /// Client-side booster opening (MVP - server-side validation done by Cloud Functions in production)
  Future<List<CardModel>> openBooster(String userId) async {
    // Check user has enough coins
    final userDoc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .get();

    if (!userDoc.exists) throw Exception('Utilisateur introuvable');
    final coins = userDoc.data()?['coins'] as int? ?? 0;
    if (coins < AppConstants.boosterCost) {
      throw Exception('Coins insuffisants (${AppConstants.boosterCost} requis)');
    }

    // Draw 3 cards with weighted rarity
    final drawnRarities = [_drawRarity(), _drawRarity(), _drawRarity()];
    final drawnCards = <CardModel>[];

    for (final rarity in drawnRarities) {
      final snap = await _firestore
          .collection(AppConstants.cardsCollection)
          .where('rarity', isEqualTo: rarity)
          .get();

      if (snap.docs.isNotEmpty) {
        final all = snap.docs;
        final picked = all[DateTime.now().microsecond % all.length];
        drawnCards.add(CardModel.fromJson(picked.data(), picked.id));
      }
    }

    // Deduct coins and add cards (batch)
    final batch = _firestore.batch();
    final userRef = _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId);

    batch.update(userRef, {
      'coins': FieldValue.increment(-AppConstants.boosterCost),
      'stats.boostersOpened': FieldValue.increment(1),
    });

    for (final card in drawnCards) {
      final cardRef = userRef
          .collection(AppConstants.cardsCollection)
          .doc(card.id);
      final existing = await cardRef.get();
      if (existing.exists) {
        batch.update(cardRef, {'count': FieldValue.increment(1)});
      } else {
        batch.set(cardRef, {
          'cardId': card.id,
          'rarity': card.rarity.value,
          'artistName': card.artistName,
          'title': card.title,
          'count': 1,
          'obtainedAt': FieldValue.serverTimestamp(),
        });
      }
    }

    // Log booster
    batch.set(_firestore.collection(AppConstants.boostersCollection).doc(), {
      'userId': userId,
      'cardsObtained': drawnCards.map((c) => c.id).toList(),
      'cost': AppConstants.boosterCost,
      'openedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
    return drawnCards;
  }

  String _drawRarity() {
    final roll = (DateTime.now().microsecond / 1000000.0);
    if (roll < AppConstants.legendaireRate) return 'legendaire';
    if (roll < AppConstants.legendaireRate + AppConstants.epiqueRate) {
      return 'epique';
    }
    if (roll < AppConstants.legendaireRate +
        AppConstants.epiqueRate +
        AppConstants.rareRate) {
      return 'rare';
    }
    return 'commune';
  }
