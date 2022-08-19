import 'package:reach_core/core/data/repositories/abstract/base_repository.dart';

mixin StreamMixin<T, E> on BaseRepository<T, E> {
  Stream<T?> streamById(String id) => remoteDataSource.streamDocument(id);

  Stream<List<T?>> streamDocsEqualsTo(String field, String value) =>
      remoteDataSource.streamDocumentsEqualsTo(field, value);

  Stream<List<E>> streamSubcollection(String docId) =>
      remoteDataSource.streamSubcollection(docId);
}
