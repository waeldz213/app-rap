// Mock collection service — Firebase désactivé pour les tests en local
import '../models/card_model.dart';
import 'mock_data.dart';

class CollectionService {
  Future<List<CardModel>> getUserCards(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return MockData.userCards;
  }

  Future<CardModel?> getCardById(String cardId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return MockData.cards.firstWhere((c) => c.id == cardId);
    } catch (_) {
      return null;
    }
  }

  Future<List<CardModel>> openBooster(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Return 3 random cards from the mock catalog
    final catalog = List<CardModel>.from(MockData.cards);
    catalog.shuffle();
    return catalog.take(3).toList();
  }
}
