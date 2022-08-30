import 'package:reach_core/core/core.dart';

class ResearcherRepository extends BaseRepository<Researcher, void> {
  ResearcherRepository({required super.remoteDatabase});

  Future<void> addResearch(String researcherId, String researchId) async =>
      await updateFieldArrayUnion(
        researcherId,
        'currentEnrollments',
        [researchId],
      );

  Future<void> endResearch(String researcherId, String researchId) async {
    await updateFieldArrayRemove(
      researcherId,
      'currentEnrollments',
      [researchId],
    );

    await remoteDatabase.incrementField(
      researcherId,
      'numberOfResearches',
    );
  }
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
