// Mock auth service — Firebase désactivé pour les tests en local
import '../models/user_model.dart';

class AuthService {
  UserModel get currentUser => _mockUser;

  final UserModel _mockUser = UserModel(
    id: 'mock-user-1',
    email: 'test@mock.com',
    displayName: 'RapFan42',
    isPremium: false,
    xp: 3400,
    level: 7,
    coins: 250,
    stats: const UserStats(),
    createdAt: DateTime(2024, 1, 1),
  );

  Future<UserModel?> signIn(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockUser;
  }

  Future<UserModel?> signUp(
      String email, String password, String displayName) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockUser;
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return signIn(email, password);
  }

  Future<UserModel?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    return signUp(email, password, displayName);
  }
}
