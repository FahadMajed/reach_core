import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DatabaseRepository<T> {
  ///returns T with its document id with it
  Future<void> createDocument(T object);

  // Future<T> createSubDocument(T object);

  ///update document by object, the object T must have an id that matches a document id;
  Future<void> updateDocument(T object);

  ///deletes document by id
  Future<void> deleteDocument(String id);

  ///used for updating a [FieldValue]
  Future<void> updateFieldArrayUnion(
    String docId,
    String field,
    List union,
  );

  Future<void> updateField(
    String docId,
    String field,
    dynamic data,
  );

  ///used for updating a [FieldValue]
  Future<void> updateFieldArrayRemove(
    String docId,
    String field,
    List remove,
  );

  ///returns object by given id, or by injected id
  Future<T?> getDocument(String id);

  ///returns object by given id
  ///[defaultFlow] is here to help if you have two implementations for the method
  Future<List<T?>> getDocuments(String clause, {bool defaultFlow = false});
}

abstract class SubCollectionRepository<E> {
  ///returns T with its document id with it
  Future<void> createSubDocument(
    String id,
    String subDocId,
    E data,
  );
}

abstract class StreamedRepository<T, E> {
  Stream<T?> streamDocument(String clause);

  Stream<List<T?>> streamDocuments(String clause);

  Stream<List<E?>> streamSubCollection(String clause);
}
