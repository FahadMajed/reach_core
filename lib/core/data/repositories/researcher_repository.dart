import 'package:reach_core/core/core.dart';

class ResearcherRepository extends BaseRepository<Researcher, void>
    implements BaseResearcher {
  ResearcherRepository({required super.remoteDatabase});

  @override
  Future<void> addResearch(String researcherId, String researchId) async =>
      await updateFieldArrayUnion(
        researcherId,
        'currentResearchsIds',
        [researchId],
      );

  @override
  Future<void> endResearch(String researcherId, String researchId) async {
    await updateFieldArrayRemove(
      researcherId,
      'currentResearchsIds',
      [researchId],
    );

    await remoteDatabase.incrementField(
      researcherId,
      'numberOfResearches',
    );
  }

  @override
  Future<void> removeResearch(String researcherId, String researchId) async =>
      await updateFieldArrayRemove(
        researcherId,
        'currentResearchsIds',
        [researchId],
      );
}

final researcherRepoPvdr = Provider(
  (ref) => ResearcherRepository(
    remoteDatabase: RemoteDatabase<Researcher, void>(
      db: ref.read(databasePvdr),
      collectionPath: "researchers",
      fromMap: (snapshot, _) => snapshot.data() != null
          ? Researcher(snapshot.data()!)
          : Researcher.empty(),
      toMap: (r, _) => r.toMap(),
    ),
  ),
);
