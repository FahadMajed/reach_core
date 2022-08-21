import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:reach_core/core/data/source/source.dart';

///T is the collection model, where E is the sub collection model.
///
///the repository is responsible on how data will be stored and fetched
///as type-safe models, it encapsulates the way of manipulating data
///with the help of different data sources, the data source is a
///accual implementation of the data source technology, for instance, firestore
///methods.
///rather than understanding how firestore works, or any other data
///source you just tell the repository
///to do the magic generacly.
///
///the use of this generic repositroy is to provide the
///subclasses the implementation of the basic CRUD operation
///the subclass must change the name of other methods
///according to the entity contract
abstract class BaseRepository<T, E> {
  @protected
  late final RemoteDatabase<T, E> _firestore;

  @protected
  RemoteDatabase<T, E> get remoteDataSource => _firestore;

  BaseRepository({
    required RemoteDatabase<T, E> remoteDataSource,
  }) {
    _firestore = remoteDataSource;
  }

  ///persists [object]

  Future<void> create(T object, String id) async =>
      await _firestore.createDocument(object, id);

  ///updates [T] field

  Future<void> updateField(String id, String field, dynamic newData) async =>
      await _firestore.updateField(id, field, newData);

  ///updates [T]

  Future<void> updateData(T object, String id) async =>
      await _firestore.updateDocument(object, id);

  ///fetches [T] using [T].id

  Future<T?> get(String id) async => await _firestore.getDocument(id);

  ///deletes [T]

  Future<void> delete(String id) async => await _firestore.deleteDocument(id);

  ///used for updating an array in the source, by adding [union] to
  ///[T] [field]
  @protected
  Future<void> updateFieldArrayUnion(
    String docId,
    String field,
    List union,
  ) async =>
      await _firestore.updateFieldArrayUnion(docId, field, union);

  ///used for updating an array in the source, by removing [remove] from
  ///[T] [field]
  @protected
  Future<void> updateFieldArrayRemove(
    String docId,
    String field,
    List remove,
  ) async =>
      await _firestore.updateFieldArrayRemove(docId, field, remove);

  @protected
  Future<List<T>> getQuery(Query<T> query) async =>
      await _firestore.getQuery(query);

  @protected
  Stream<List<T>> streamQuery(Query<T> query) => _firestore.streamQuery(query);

  @protected
  Stream<List<E>> streamSubcollectionQuery(Query<E> query) =>
      _firestore.streamSubcollectionQuery(query);

  @protected
  Future<List<E>> getQuerySubcollection(Query<E> query) async =>
      await _firestore.getQuerySubcollection(query);

  @protected
  Future<void> createSubdocument(
    String id,
    String subDocId,
    E data,
  ) async =>
      await remoteDataSource.createSubdocument(
        parentId: id,
        subDocId: subDocId,
        data: data,
      );

  @protected
  Future<void> addListToSubdocument(
    String id,
    String subDocId,
    List<E> data,
  ) async =>
      await remoteDataSource.addListToSubdocument(
        id: id,
        subDocId: subDocId,
        data: data,
      );
}
