import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/daily_challenge_model.dart';
import '../services/daily_challenge_service.dart';
import 'auth_provider.dart';

final dailyChallengeServiceProvider =
    Provider<DailyChallengeService>((ref) {
  return DailyChallengeService(ref.watch(firestoreServiceProvider));
});

final todayChallengeProvider =
    FutureProvider.autoDispose<DailyChallengeModel?>((ref) {
  return ref.watch(dailyChallengeServiceProvider).getTodayChallenge();
});

final hasCompletedTodayProvider =
    FutureProvider.autoDispose<bool>((ref) async {
  final authService = ref.watch(authServiceProvider);
  final userId = authService.currentUser?.uid;
  if (userId == null) return false;
  return ref.watch(dailyChallengeServiceProvider).hasUserCompletedToday(userId);
});
