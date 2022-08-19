import 'package:cloud_firestore/cloud_firestore.dart';

///T is the collection model, where E is the sub collection model

class FirestoreDataSource<T, E> {
  late final FirebaseFirestore _db;

  late final CollectionReference<T> _collection;

  late final T Function(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) _fromMap;

  late final Map<String, Object?> Function(T, SetOptions?) _toMap;

  late final String? _subCollectionPath;

  late final E Function(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options)? _subFromMap;

  late final Map<String, Object?> Function(E, SetOptions?)? _subToMap;

  FirestoreDataSource({
    required FirebaseFirestore db,
    required String collectionPath,
    required T Function(DocumentSnapshot<Map<String, dynamic>> snapshot,
            SnapshotOptions? options)
        fromMap,
    required Map<String, Object?> Function(T, SetOptions?) toMap,
    String subCollectionPath = "",
    E Function(DocumentSnapshot<Map<String, dynamic>> snapshot,
            SnapshotOptions? options)?
        subFromMap,
    Map<String, Object?> Function(E, SetOptions?)? subToMap,
  }) {
    _db = db;
    _fromMap = fromMap;
    _toMap = toMap;
    _subCollectionPath = subCollectionPath;
    _subFromMap = subFromMap;
    _subToMap = subToMap;
    _collection = _db
        .collection(collectionPath)
        .withConverter<T>(fromFirestore: _fromMap, toFirestore: toMap);
  }

  Future<void> createDocument(T object, String id) async =>
      await _collection.doc(id).set(object);

  ///update document by object, the object T must have an id that matches a document id;
  Future<void> updateDocument(T object, String id) async =>
      await _collection.doc(id).update(_toMap(object, null));

  ///deletes document by id
  Future<void> deleteDocument(String id) async =>
      await _collection.doc(id).delete();

  ///used for updating a [FieldValue]
  Future<void> updateFieldArrayUnion(
    String docId,
    String field,
    List union,
  ) async =>
      await _collection
          .doc(docId)
          .update({field: FieldValue.arrayUnion(union)});

  Future<void> updateField(
    String docId,
    String field,
    dynamic data,
  ) async =>
      await _collection.doc(docId).update({field: data});

  ///used for updating a [FieldValue]
  Future<void> updateFieldArrayRemove(
    String docId,
    String field,
    List remove,
  ) async =>
      await _collection
          .doc(docId)
          .update({field: FieldValue.arrayRemove(remove)});

  ///returns object by given id, or by injected id
  Future<T?> getDocument(String id) async =>
      await _collection.doc(id).get().then((doc) => doc.data());

  ///returns object by given id, or by injected id
  Future<List<T>> getDocuments(int? limit) async => limit == null
      ? await _collection
          .get()
          .then((query) => query.docs.map((doc) => doc.data()).toList())
      : await _collection
          .limit(limit)
          .get()
          .then((query) => query.docs.map((doc) => doc.data()).toList());

  ///returns list of documents where [field] is equals to [value]
  Future<List<T?>> getDocumentsEqualsTo(String field, String value) async =>
      await _collection
          .where(field, isEqualTo: value)
          .get()
          .then((query) => query.docs.map((e) => e.data()).toList());

  Future<List<T?>> getDocumentsWhereIn(String field, List list) async =>
      await _collection
          .where(field, whereIn: list)
          .get()
          .then((query) => query.docs.map((e) => e.data()).toList());

  Future<List<T?>> getDocumentsWhereEqualsAndIn({
    required String fieldEquals,
    required dynamic clause,
    required String fieldIn,
    required List list,
  }) =>
      _collection
          .where(fieldEquals, isEqualTo: clause)
          .where(fieldIn, whereIn: list)
          .get()
          .then((value) => value.docs.map((doc) => doc.data()).toList());

  Future<void> createSubdocument({
    required String id,
    required String subDocId,
    required E data,
  }) async =>
      await _collection
          .doc(id)
          .collection(_subCollectionPath!)
          .withConverter<E>(
              fromFirestore: _subFromMap!, toFirestore: _subToMap!)
          .doc(subDocId)
          .set(data);

  Future<void> addListToSubdocument({
    required String id,
    required String subDocId,
    required List<E> data,
  }) async =>
      await _collection
          .doc(id)
          .collection(_subCollectionPath!)
          .doc(subDocId)
          .set(
        {
          subDocId: data.map((e) => _subToMap!(e, null)).toList(),
        },
      );

  Stream<T?> streamDocument(String id) =>
      _collection.doc(id).snapshots().map((event) => event.data());

  Stream<List<T?>> streamDocumentsEqualsTo(String field, String value) =>
      _collection
          .where(field, isEqualTo: value)
          .snapshots()
          .map((event) => event.docs.map((e) => e.data()).toList());

  Stream<List<E>> streamSubcollection(String docId) => _collection
      .doc(docId)
      .collection(_subCollectionPath!)
      .withConverter<E>(fromFirestore: _subFromMap!, toFirestore: _subToMap!)
      .snapshots()
      .map((event) => event.docs.map((e) => e.data()).toList());
}
