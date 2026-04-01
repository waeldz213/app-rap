import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> signUpWithEmailPassword(
      String email, String password, String username) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await credential.user?.updateDisplayName(username);
    await createUserProfile(credential.user!.uid, username, email.trim());
    return credential;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Google sign-in stub - requires google_sign_in package integration
  Future<UserCredential?> signInWithGoogle() async {
    throw UnimplementedError(
        'Google sign-in requires google_sign_in package setup.');
  }

  Future<void> createUserProfile(
      String uid, String username, String email) async {
    final userModel = UserModel(
      id: uid,
      username: username,
      email: email,
      coins: 100,
      xp: 0,
      level: 1,
      rankPoints: 0,
      rankTier: 'Bronze',
      streak: 0,
      isPremium: false,
      stats: const UserStats(
        totalGamesPlayed: 0,
        totalCorrectAnswers: 0,
        totalDuelsPlayed: 0,
        totalDuelWins: 0,
        totalDuelLosses: 0,
      ),
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection('users')
        .doc(uid)
        .set(userModel.toJson());
  }

  Future<void> updatePassword(String newPassword) async {
    await _auth.currentUser?.updatePassword(newPassword);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }
}
