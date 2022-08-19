import 'package:reach_core/core/core.dart';

mixin QueryMixin<T, E> on BaseRepository<T, E> {
  Future<List<T?>> getWhereEquals({
    required String field,
    required String value,
  }) async =>
      await remoteDataSource.getDocumentsEqualsTo(field, value);

  Future<List<T?>> getWhereIn({
    required String field,
    required List list,
  }) async =>
      await remoteDataSource.getDocumentsWhereIn(field, list);

  Future<List<T?>> getWhereInAndEqualsTo({
    required String fieldIn,
    required List list,
    required String fieldEquals,
    required String to,
  }) async =>
      await getWhereInAndEqualsTo(
        fieldIn: fieldIn,
        list: list,
        fieldEquals: fieldEquals,
        to: to,
      );
}
