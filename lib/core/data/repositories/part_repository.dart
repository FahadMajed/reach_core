import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class ParticipantsRepository extends BaseRepository<Participant, Answer>
    with
        FetchAllMixin<Participant, Answer>,
        SubcollectionMixin<Participant, Answer> {
  ParticipantsRepository({required super.remoteDataSource});
}

final partsRepoPvdr = Provider(
  (ref) => ParticipantsRepository(
    remoteDataSource: FirestoreDataSource<Participant, Answer>(
      db: ref.read(databaseProvider),
      collectionPath: "participants",
      fromMap: (snapshot, _) => snapshot.data() != null
          ? Participant(snapshot.data()!)
          : Participant.empty(),
      toMap: (p, _) => p.toMap(),
      subCollectionPath: "answers",
      subFromMap: (snapshot, _) => snapshot.data() != null
          ? Answer.fromMap(snapshot.data()!)
          : Answer.empty(),
      subToMap: (a, _) => a.toMap(),
    ),
  ),
);
