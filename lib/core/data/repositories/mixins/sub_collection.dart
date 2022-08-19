import 'package:reach_core/core/core.dart';

mixin SubcollectionMixin<T, E> on BaseRepository<T, E> {
  Future<void> createSubdocument(
    String id,
    String subDocId,
    E data,
  ) async =>
      await remoteDataSource.createSubdocument(
        id: id,
        subDocId: subDocId,
        data: data,
      );

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
