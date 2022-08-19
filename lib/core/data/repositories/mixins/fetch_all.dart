import 'package:reach_core/core/data/repositories/abstract/base_repository.dart';

mixin FetchAllMixin<T, E> on BaseRepository<T, E> {
  Future<List<T>> getDocuments(int limit) async =>
      await remoteDataSource.getDocuments(limit);
}
