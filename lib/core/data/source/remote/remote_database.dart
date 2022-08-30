import 'package:cloud_firestore/cloud_firestore.dart';

///T is the collection model, where E is the sub collection model

class RemoteDatabase<T, E> {
  late final FirebaseFirestore _db;

  late final CollectionReference<T> _collection;

  late final T Function(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) _fromMap;

  late final Map<String, Object?> Function(T, SetOptions?) _toMap;

  late final String? _subCollectionPath;

  late final E Function(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options)? _subFromMap;

  late final Map<String, Object?> Function(E, SetOptions?)? _subToMap;

  RemoteDatabase({
    required FirebaseFirestore db,
    required String collectionPath,
    required T Function(
            DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? _)
        fromMap,
    required Map<String, Object?> Function(T object, SetOptions? _) toMap,
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

  CollectionReference<E> getSubCollection(String parentId) => _db
      .collection(_collection.id)
      .doc(parentId)
      .collection(_subCollectionPath!)
      .withConverter<E>(fromFirestore: _subFromMap!, toFirestore: _subToMap!);

  Query<T> Function(Object,
      {Object? arrayContains,
      List<Object?>? arrayContainsAny,
      Object? isEqualTo,
      Object? isGreaterThan,
      Object? isGreaterThanOrEqualTo,
      Object? isLessThan,
      Object? isLessThanOrEqualTo,
      Object? isNotEqualTo,
      bool? isNull,
      List<Object?>? whereIn,
      List<Object?>? whereNotIn}) get where => _collection.where;

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

  Future<void> createSubdocument({
    required String parentId,
    required String subDocId,
    required E data,
  }) async =>
      await getSubCollection(parentId).doc(subDocId).set(data);

  ///GENERATES ID FOR DOC
  Future<String> createSubdocumentNoId({
    required String parentId,
    required E data,
  }) async =>
      await getSubCollection(parentId).add(data).then((doc) => doc.id);

  Future<void> updateSubdoc(
          String parentId, String subDocId, Map<String, Object?> data) async =>
      await getSubCollection(parentId).doc(subDocId).update(data);

  Future<void> deleteSubdoc(String parentId, String subDocId) async =>
      await getSubCollection(parentId).doc(subDocId).delete();

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

  Future<List<T>> getQuery(Query<T> query) async => await query
      .get()
      .then((value) => value.docs.map((e) => e.data()).toList());

  Future<List<E>> getQuerySubcollection(Query<E> query) async => await query
      .get()
      .then((value) => value.docs.map((e) => e.data()).toList());

  Stream<List<T>> streamQuery(Query<T> query) => query
      .snapshots()
      .map((value) => value.docs.map((e) => e.data()).toList());

  Stream<List<E>> streamSubcollectionQuery(Query<E> query) => query
      .snapshots()
      .map((value) => value.docs.map((e) => e.data()).toList());

  Future<void> incrementField(String docId, String field) async {
    await _collection.doc(docId).update({field: FieldValue.increment(1)});
  }
}
