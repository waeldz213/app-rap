import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/duel_model.dart';
import '../services/duel_service.dart';

final duelServiceProvider = Provider<DuelService>((ref) => DuelService());

final duelStreamProvider =
    StreamProvider.family<DuelModel?, String>((ref, duelId) {
  return ref.watch(duelServiceProvider).listenToDuel(duelId);
});
