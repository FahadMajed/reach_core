import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

abstract class IParticipantRepository {
  //CRUD +
  Future<void> removeCurrentEnrollment(String id, String researchId);
  Future<void> addAnswers(String id, String answersId, List<Answer> asnwers);
}

class ParticipantsRepository extends BaseRepository<Participant, Answer>
    implements IParticipantRepository {
  ParticipantsRepository({required super.remoteDataSource});

  @override
  Future<void> removeCurrentEnrollment(String id, String researchId) async =>
      await updateFieldArrayRemove(id, 'currentEnrollments', [researchId]);

  @override
  Future<void> addAnswers(
          String id, String answersId, List<Answer> asnwers) async =>
      await addListToSubdocument(id, answersId, asnwers);
}

final partsRepoPvdr = Provider(
  (ref) => ParticipantsRepository(
    remoteDataSource: RemoteDatabase<Participant, Answer>(
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
