// Mock user provider — Firebase désactivé pour les tests en local
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/mock_data.dart';

final userModelProvider = StreamProvider<UserModel?>((ref) {
  return Stream.value(MockData.currentUser);
});
