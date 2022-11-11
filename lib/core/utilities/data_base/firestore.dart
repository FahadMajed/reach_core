import 'package:reach_core/core/core.dart';

class FirestoreRemoteDatabase<T, E> implements RemoteDatabase<T, E> {
  late final FirebaseFirestore _db;

  late final CollectionReference<T> _collection;

  late final T Function(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) _fromMap;

  @override
  FieldValue increment(num number) => FieldValue.increment(number);

  @override
  FieldValue decrement(num number) => FieldValue.increment(-number);

  @override
  FieldValue arrayUnion(List union) => FieldValue.arrayUnion(union);

  @override
  FieldValue arrayRemove(List remove) => FieldValue.arrayRemove(remove);

  @override
  FieldValue delete() => FieldValue.delete();

  late final Map<String, Object?> Function(T, SetOptions?) _toMap;

  late final String? _subCollectionPath;

  late final E Function(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options)? _subFromMap;

  late final Map<String, Object?> Function(E, SetOptions?)? _subToMap;

  FirestoreRemoteDatabase({
    required FirebaseFirestore db,
    required String collectionPath,
    required T Function(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? _) fromMap,
    required Map<String, Object?> Function(T object, SetOptions? _) toMap,
    String subCollectionPath = "",
    E Function(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options)? subFromMap,
    Map<String, Object?> Function(E, SetOptions?)? subToMap,
  }) {
    _db = db;
    _fromMap = fromMap;
    _toMap = toMap;
    _subCollectionPath = subCollectionPath;
    _subFromMap = subFromMap;
    _subToMap = subToMap;
    _collection = _db.collection(collectionPath).withConverter<T>(fromFirestore: _fromMap, toFirestore: toMap);
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

  @override
  Future<void> createDocument(T object, String id) async => await _collection.doc(id).set(object);

  ///update document by object, the object T must have an id that matches a document id;
  @override
  Future<void> updateDocument(T object, String id) async => await _collection.doc(id).update(_toMap(object, null));

  @override
  Future<void> updateDocumentRaw(Map<String, Object?> data, String id) async => await _collection.doc(id).update(data);

  @override
  Future<bool> docExists(String docId) async =>
      await _collection.doc(docId).get().then((doc) => doc.exists) ? true : false;

  ///deletes document by id
  @override
  Future<void> deleteDocument(String id) async => await _collection.doc(id).delete();

  ///used for updating a [FieldValue]
  @override
  Future<void> updateFieldArrayUnion(
    String docId,
    String field,
    List union,
  ) async =>
      await docExists(docId) ? await _collection.doc(docId).update({field: arrayUnion(union)}) : null;

  @override
  Future<void> updateField(
    String docId,
    String field,
    dynamic data,
  ) async =>
      await _collection.doc(docId).update({field: data});

  ///used for updating a [FieldValue]
  @override
  Future<void> updateFieldArrayRemove(
    String docId,
    String field,
    List remove,
  ) async =>
      await _collection.doc(docId).update({field: arrayRemove(remove)});

  ///returns object by given id, or by injected id
  @override
  Future<T> getDocument(String id) async {
    return await _collection
        .doc(id)
        .get()
        .then((doc) => doc.data() == null ? throw Exception("DOC WITH $id NOT FOUND") : doc.data()!);
  }

  ///returns object by given id, or by injected id
  @override
  Future<List<T>> getDocuments(int? limit) async => limit == null
      ? await _collection.get().then((query) => query.docs.map((doc) => doc.data()).toList())
      : await _collection.limit(limit).get().then((query) => query.docs.map((doc) => doc.data()).toList());

  ///returns list of documents where [field] is equals to [description]

  @override
  Future<void> createSubdocument({
    required String parentId,
    required String subDocId,
    required E data,
  }) async =>
      await getSubCollection(parentId).doc(subDocId).set(data);

  // @override
  // Future<void> addElementToSubcollectionDocumentField({
  //   required String parentId,
  //   required String subDocId,
  //   required String field,
  //   required E data,
  // }) async =>
  //     await getSubCollection(parentId).doc(subDocId).update({
  //       field: arrayUnion([data])
  //     });

  @override
  Future<void> updateSubdocField(
    String parentId,
    String docId,
    String field,
    dynamic data,
  ) async =>
      await getSubCollection(parentId).doc(docId).update({field: data});

  @override
  Future<List<E>> getAllSubcollection(String parentId) async =>
      await getSubCollection(parentId).get().then((query) => query.docs.map((e) => e.data()).toList());

  ///GENERATES ID FOR DOC
  @override
  Future<String> createSubdocumentNoId({
    required String parentId,
    required E data,
  }) async =>
      await getSubCollection(parentId).add(data).then((doc) => doc.id);

  @override
  Future<void> updateSubdoc(String parentId, String subDocId, Map<String, Object?> data) async =>
      await getSubCollection(parentId).doc(subDocId).update(data);

  @override
  Future<void> deleteSubdoc(String parentId, String subDocId) async =>
      await getSubCollection(parentId).doc(subDocId).delete();

  // @override
  // Future<void> addListToSubdocument({
  //   required String id,
  //   required String subDocId,
  //   required List<E> data,
  // }) async =>
  //     await _collection.doc(id).collection(_subCollectionPath!).doc(subDocId).set(
  //       {
  //         subDocId: data.map((e) => _subToMap!(e, null)).toList(),
  //       },
  //     );

  @override
  Stream<T?> streamDocument(String id) => _collection.doc(id).snapshots().map((event) => event.data());

  @override
  Future<List<T>> getQuery(DatabaseQuery<T> query) async {
    final firestoreQuery = query.parseAsFirestore(_collection);

    return await firestoreQuery.get().then(
          (value) => value.docs.map((e) => e.data()).toList(),
        );
  }

  @override
  Future<List<E>> getQuerySubcollection(
    String parentId,
    DatabaseQuery<E> query,
  ) async {
    final firestoreQuery = query.parseAsFirestore(getSubCollection(parentId));
    return await firestoreQuery.get().then((value) => value.docs.map((e) => e.data()).toList());
  }

  @override
  Stream<List<T>> streamQuery(DatabaseQuery<T> query) {
    final firestoreQuery = query.parseAsFirestore(_collection);

    return firestoreQuery.snapshots().map((value) => value.docs.map((e) => e.data()).toList());
  }

  @override
  Stream<List<E>> streamSubcollectionQuery(
    String parentId,
    DatabaseQuery<E> query,
  ) {
    final firestoreQuery = query.parseAsFirestore(getSubCollection(parentId));

    return firestoreQuery.snapshots().map((value) => value.docs.map((e) => e.data()).toList());
  }

  @override
  Future<void> incrementField(
    String docId,
    String field, {
    num? by,
  }) async =>
      await _collection.doc(docId).update({field: increment(by ?? 1)});

  @override
  Future<void> decrementField(
    String docId,
    String field, {
    num? by,
  }) async =>
      await _collection.doc(docId).update({field: decrement(by ?? 1)});
}
