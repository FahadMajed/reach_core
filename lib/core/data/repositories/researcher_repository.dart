import 'package:reach_core/core/core.dart';

class ResearcherRepository extends BaseRepository<Researcher, void> {
  ResearcherRepository({required super.remoteDatabase});
}

final researcherRepoPvdr = Provider(
  (ref) => ResearcherRepository(
    remoteDatabase: RemoteDatabase<Researcher, void>(
      db: ref.read(databaseProvider),
      collectionPath: "researchers",
      fromMap: (snapshot, _) => snapshot.data() != null
          ? Researcher(snapshot.data()!)
          : Researcher.empty(),
      toMap: (r, _) => r.toMap(),
    ),
  ),
);
