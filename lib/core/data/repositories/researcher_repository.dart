import 'package:reach_core/core/core.dart';

class ResearcherRepository extends BaseRepository<Researcher, void> {
  ResearcherRepository({required super.remoteDataSource});
}

final researcherRepoPvdr = Provider((ref) => ResearcherRepository(
      remoteDataSource: FirestoreDataSource<Researcher, void>(
        db: ref.read(databaseProvider),
        collectionPath: "participants",
        fromMap: (snapshot, _) => snapshot.data() != null
            ? Researcher(snapshot.data()!)
            : Researcher.empty(),
        toMap: (r, _) => r.toMap(),
      ),
    ));
