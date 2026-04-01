import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/card_model.dart';
import '../providers/auth_provider.dart';
import '../services/collection_service.dart';

final collectionServiceProvider =
    Provider<CollectionService>((ref) => CollectionService());

final userCardsProvider = FutureProvider<List<CardModel>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Future.value([]);
  return ref.watch(collectionServiceProvider).getUserCards(user.uid);
});

final cardDetailProvider =
    FutureProvider.family<CardModel?, String>((ref, cardId) {
  return ref.watch(collectionServiceProvider).getCardById(cardId);
});
