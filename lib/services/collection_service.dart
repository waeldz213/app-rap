import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/card_model.dart';
import 'firestore_service.dart';

class CollectionService {
  final FirestoreService _firestoreService;

  CollectionService(this._firestoreService);

  Future<List<CardModel>> getUserCards(String userId) async {
    final userCardsSnapshot = await _firestoreService.userCards
        .where('userId', isEqualTo: userId)
        .get();

    final cardIds = userCardsSnapshot.docs
        .map((doc) => (doc.data() as Map<String, dynamic>)['cardId'] as String)
        .toSet()
        .toList();

    if (cardIds.isEmpty) return [];

    final cards = <CardModel>[];
    // Firestore whereIn supports max 10 items per query
    for (int i = 0; i < cardIds.length; i += 10) {
      final chunk = cardIds.sublist(
          i, i + 10 > cardIds.length ? cardIds.length : i + 10);
      final cardsSnapshot = await _firestoreService.cards
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      for (final doc in cardsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        cards.add(CardModel.fromJson({...data, 'id': doc.id}));
      }
    }

    return cards;
  }

  Future<void> addCardToCollection(String userId, String cardId) async {
    await _firestoreService.userCards.add({
      'userId': userId,
      'cardId': cardId,
      'acquiredAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> equipCard(String userId, String cardId) async {
    await _firestoreService.users.doc(userId).update({
      'equippedCardId': cardId,
    });
  }

  Future<Set<String>> getUserCardIds(String userId) async {
    final snapshot = await _firestoreService.userCards
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) =>
            (doc.data() as Map<String, dynamic>)['cardId'] as String)
        .toSet();
  }

  Future<CardModel?> getCardById(String cardId) async {
    final doc = await _firestoreService.cards.doc(cardId).get();
    if (!doc.exists) return null;
    final data = doc.data() as Map<String, dynamic>;
    return CardModel.fromJson({...data, 'id': doc.id});
  }
}
