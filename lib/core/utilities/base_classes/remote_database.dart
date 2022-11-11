import 'package:reach_core/core/core.dart';

///T is the collection model, where E is the sub collection model

abstract class RemoteDatabase<T, E> {
  dynamic increment(num number);

  dynamic decrement(num number);

  dynamic arrayUnion(List union);

  dynamic arrayRemove(List remove);

  dynamic delete();

  Future<void> createDocument(T object, String id);

  ///update document by object, the object T must have an id that matches a document id;
  Future<void> updateDocument(T object, String id);

  Future<void> updateDocumentRaw(Map<String, Object?> data, String id);

  Future<bool> docExists(String docId);

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
  Future<T> getDocument(String id);

  ///returns object by given id, or by injected id
  Future<List<T>> getDocuments(int? limit);

  ///returns list of documents where [field] is equals to [description]

  Future<void> createSubdocument({
    required String parentId,
    required String subDocId,
    required E data,
  });

  Future<void> updateSubdocField(
    String parentId,
    String docId,
    String field,
    dynamic data,
  );

  Future<List<E>> getAllSubcollection(String parentId);

  ///GENERATES ID FOR DOC
  Future<String> createSubdocumentNoId({
    required String parentId,
    required E data,
  });

  Future<void> updateSubdoc(
    String parentId,
    String subDocId,
    Map<String, Object?> data,
  );

  Future<void> deleteSubdoc(String parentId, String subDocId);

  // Future<void> addListToSubdocument({
  //   required String id,
  //   required String subDocId,
  //   required List<E> data,
  // });

  Stream<T?> streamDocument(String id);

  Future<List<T>> getQuery(DatabaseQuery<T> query);

  Future<List<E>> getQuerySubcollection(
    String parentId,
    DatabaseQuery<E> query,
  );

  Stream<List<T>> streamQuery(DatabaseQuery<T> query);

  Stream<List<E>> streamSubcollectionQuery(
    String parentId,
    DatabaseQuery<E> query,
  );

  Future<void> incrementField(String docId, String field);

  Future<void> decrementField(String docId, String field);

  // Future<void> addElementToSubcollectionDocumentField({
  //   required String parentId,
  //   required String subDocId,
  //   required String field,
  //   required E data,
  // });
}
