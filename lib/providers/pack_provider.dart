import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pack_model.dart';
import '../services/pack_service.dart';
import 'auth_provider.dart';

final packServiceProvider = Provider<PackService>((ref) {
  return PackService(ref.watch(firestoreServiceProvider));
});

final packsProvider = FutureProvider<List<PackModel>>((ref) {
  return ref.watch(packServiceProvider).getPacks();
});

final freePacksProvider = FutureProvider<List<PackModel>>((ref) {
  return ref.watch(packServiceProvider).getFreePacks();
});

final premiumPacksProvider = FutureProvider<List<PackModel>>((ref) {
  return ref.watch(packServiceProvider).getPremiumPacks();
});

final packDetailProvider =
    FutureProvider.family<PackModel?, String>((ref, packId) {
  return ref.watch(packServiceProvider).getPackById(packId);
});
