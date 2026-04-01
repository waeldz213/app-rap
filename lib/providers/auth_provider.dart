// Mock auth provider — Firebase désactivé pour les tests en local
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

/// Simule un utilisateur Firebase avec les propriétés utilisées dans l'app.
class MockUser {
  final String uid;
  final String? displayName;
  final String? email;

  const MockUser({
    required this.uid,
    this.displayName,
    this.email,
  });
}

final _mockUser = const MockUser(
  uid: 'mock-user-1',
  displayName: 'RapFan42',
  email: 'test@mock.com',
);

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Toujours authentifié en mode mock
final authStateProvider = StreamProvider<MockUser?>((ref) {
  return Stream.value(_mockUser);
});

final currentUserProvider = Provider<MockUser?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});
