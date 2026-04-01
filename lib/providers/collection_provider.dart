import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/card_model.dart';
import '../services/collection_service.dart';
import 'auth_provider.dart';

final collectionServiceProvider = Provider<CollectionService>((ref) {
  return CollectionService(ref.watch(firestoreServiceProvider));
});

final userCardsProvider = FutureProvider.autoDispose<List<CardModel>>((ref) async {
  final authService = ref.watch(authServiceProvider);
  final userId = authService.currentUser?.uid;
  if (userId == null) return [];
  return ref.watch(collectionServiceProvider).getUserCards(userId);
});

final userCardIdsProvider =
    FutureProvider.autoDispose<Set<String>>((ref) async {
  final authService = ref.watch(authServiceProvider);
  final userId = authService.currentUser?.uid;
  if (userId == null) return {};
  return ref.watch(collectionServiceProvider).getUserCardIds(userId);
});

final cardDetailProvider =
    FutureProvider.autoDispose.family<CardModel?, String>((ref, cardId) {
  return ref.watch(collectionServiceProvider).getCardById(cardId);
});
