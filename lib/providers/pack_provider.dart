import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pack_model.dart';
import '../services/pack_service.dart';

final packServiceProvider = Provider<PackService>((ref) => PackService());

final packsProvider = FutureProvider<List<PackModel>>((ref) {
  return ref.watch(packServiceProvider).getPacks();
});

final packDetailProvider =
    FutureProvider.family<PackModel?, String>((ref, packId) {
  return ref.watch(packServiceProvider).getPackById(packId);
});
