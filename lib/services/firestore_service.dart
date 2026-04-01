import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FirebaseFirestore get db => _db;

  // Collection references
  CollectionReference get users => _db.collection('users');
  CollectionReference get packs => _db.collection('packs');
  CollectionReference get questions => _db.collection('questions');
  CollectionReference get cards => _db.collection('cards');
  CollectionReference get userCards => _db.collection('userCards');
  CollectionReference get duels => _db.collection('duels');
  CollectionReference get dailyChallenges => _db.collection('dailyChallenges');
  CollectionReference get transactions => _db.collection('transactions');

  Future<DocumentSnapshot> getDocument(
      String collection, String docId) async {
    return _db.collection(collection).doc(docId).get();
  }

  Future<void> setDocument(
      String collection, String docId, Map<String, dynamic> data) async {
    await _db.collection(collection).doc(docId).set(data);
  }

  Future<void> updateDocument(
      String collection, String docId, Map<String, dynamic> data) async {
    await _db.collection(collection).doc(docId).update(data);
  }

  Future<void> deleteDocument(String collection, String docId) async {
    await _db.collection(collection).doc(docId).delete();
  }

  Future<DocumentReference> addDocument(
      String collection, Map<String, dynamic> data) async {
    return _db.collection(collection).add(data);
  }

  Stream<DocumentSnapshot> documentStream(String collection, String docId) {
    return _db.collection(collection).doc(docId).snapshots();
  }

  Stream<QuerySnapshot> collectionStream(
    String collection, {
    List<List<dynamic>>? whereConditions,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) {
    Query query = _db.collection(collection);

    if (whereConditions != null) {
      for (final condition in whereConditions) {
        if (condition.length == 3) {
          query = query.where(
            condition[0] as String,
            isEqualTo: condition[1] == '==' ? condition[2] : null,
          );
        }
      }
    }

    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots();
  }

  /// Convert Firestore Timestamp or DateTime to DateTime
  static DateTime? toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  /// Convert DateTime to Firestore Timestamp
  static Timestamp? toTimestamp(DateTime? value) {
    if (value == null) return null;
    return Timestamp.fromDate(value);
  }
}
