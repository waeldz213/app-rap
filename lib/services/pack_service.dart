import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pack_model.dart';
import 'firestore_service.dart';

class PackService {
  final FirestoreService _firestoreService;

  PackService(this._firestoreService);

  Future<List<PackModel>> getPacks() async {
    final snapshot = await _firestoreService.packs
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return PackModel.fromJson({...data, 'id': doc.id});
    }).toList();
  }

  Future<PackModel?> getPackById(String packId) async {
    final doc = await _firestoreService.packs.doc(packId).get();
    if (!doc.exists) return null;
    final data = doc.data() as Map<String, dynamic>;
    return PackModel.fromJson({...data, 'id': doc.id});
  }

  Future<List<PackModel>> getFreePacks() async {
    final snapshot = await _firestoreService.packs
        .where('isActive', isEqualTo: true)
        .where('isPremium', isEqualTo: false)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return PackModel.fromJson({...data, 'id': doc.id});
    }).toList();
  }

  Future<List<PackModel>> getPremiumPacks() async {
    final snapshot = await _firestoreService.packs
        .where('isActive', isEqualTo: true)
        .where('isPremium', isEqualTo: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return PackModel.fromJson({...data, 'id': doc.id});
    }).toList();
  }

  Stream<List<PackModel>> packsStream() {
    return _firestoreService.packs
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return PackModel.fromJson({...data, 'id': doc.id});
            }).toList());
  }

  Future<void> incrementPackPlays(String packId) async {
    await _firestoreService.packs.doc(packId).update({
      'totalPlays': FieldValue.increment(1),
    });
  }
}
