import 'package:flutter/foundation.dart';
import 'package:reach_core/core/data/source/source.dart';

///T is the collection model, where E is the sub collection model
class BaseRepository<T, E> {
  @protected
  late final FirestoreDataSource<T, E> _firestore;

  @protected
  FirestoreDataSource<T, E> get remoteDataSource => _firestore;

  BaseRepository({
    required FirestoreDataSource<T, E> remoteDataSource,
  }) {
    _firestore = remoteDataSource;
  }

  ///persists [object]
  Future<void> create(T object, String id) async =>
      await _firestore.createDocument(object, id);

  ///updates [T] field

  Future<void> updateEntityField(
          String id, String field, dynamic newData) async =>
      await _firestore.updateField(id, field, newData);

  ///updates [T]
  Future<void> updateData(T object, String id) async =>
      await _firestore.updateDocument(object, id);

  ///fetches data using id
  Future<T?> get(String id) async => await _firestore.getDocument(id);

  ///deletes [T]
  Future<void> delete(String id) async => await _firestore.deleteDocument(id);

  ///used for updating an array in the source, by adding [union] to
  ///[T] [field]

  Future<void> updateFieldArrayUnion(
    String docId,
    String field,
    List union,
  ) async =>
      await _firestore.updateFieldArrayUnion(docId, field, union);

  ///used for updating an array in the source, by removing [remove] from
  ///[T] [field]

  Future<void> updateFieldArrayRemove(
    String docId,
    String field,
    List remove,
  ) async =>
      await _firestore.updateFieldArrayRemove(docId, field, remove);
}
