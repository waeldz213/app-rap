import 'package:cloud_firestore/cloud_firestore.dart';

class QueryFilter {
  final String field;
  final dynamic value;

  const QueryFilter({required this.field, required this.value});
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get instance => _firestore;

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
    String collection,
    String id,
  ) async {
    return await _firestore.collection(collection).doc(id).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCollection(
    String collection, {
    List<QueryFilter>? filters,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) async {
    Query<Map<String, dynamic>> query = _firestore.collection(collection);
    if (filters != null) {
      for (final filter in filters) {
        query = query.where(filter.field, isEqualTo: filter.value);
      }
    }
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }
    if (limit != null) {
      query = query.limit(limit);
    }
    return await query.get();
  }

  Future<void> setDocument(
    String collection,
    String id,
    Map<String, dynamic> data, {
    bool merge = false,
  }) async {
    await _firestore
        .collection(collection)
        .doc(id)
        .set(data, SetOptions(merge: merge));
  }

  Future<void> updateDocument(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    await _firestore.collection(collection).doc(id).update(data);
  }

  Future<void> deleteDocument(String collection, String id) async {
    await _firestore.collection(collection).doc(id).delete();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamDocument(
    String collection,
    String id,
  ) {
    return _firestore.collection(collection).doc(id).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection(
    String collection, {
    List<QueryFilter>? filters,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(collection);
    if (filters != null) {
      for (final filter in filters) {
        query = query.where(filter.field, isEqualTo: filter.value);
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

  Future<DocumentReference<Map<String, dynamic>>> addDocument(
    String collection,
    Map<String, dynamic> data,
  ) async {
    return await _firestore.collection(collection).add(data);
  }
}
