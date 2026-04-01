// Mock auth service — Firebase désactivé pour les tests en local
import '../models/user_model.dart';
import 'mock_data.dart';

class AuthService {
  UserModel get currentUser => MockData.currentUser;

  Future<UserModel?> signIn(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.currentUser;
  }

  Future<UserModel?> signUp(
      String email, String password, String displayName) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockData.currentUser;
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
