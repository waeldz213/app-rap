import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/daily_challenge_model.dart';
import '../providers/auth_provider.dart';
import '../services/daily_challenge_service.dart';

final dailyChallengeServiceProvider =
    Provider<DailyChallengeService>((ref) => DailyChallengeService());

final dailyChallengeProvider =
    FutureProvider<DailyChallengeModel?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Future.value(null);
  return ref
      .watch(dailyChallengeServiceProvider)
      .getTodaysChallenge(user.uid);
});
