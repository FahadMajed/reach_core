import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class ParticipantsRepository extends BaseRepository<Participant, Answer>
    implements BaseParticipant {
  ParticipantsRepository({required super.remoteDatabase});

  @override
  Future<void> removeEnrollment(String id, String researchId) async =>
      await updateFieldArrayRemove(id, 'currentEnrollments', [researchId]);

  @override
  Future<void> addEnrollment(String id, String researchId) async =>
      await updateFieldArrayUnion(id, 'currentEnrollments', [researchId]);

  @override
  Future<void> addAnswers(
          String id, String answersId, List<Answer> asnwers) async =>
      await addListToSubdocument(id, answersId, asnwers);
}

final partsRepoPvdr = Provider(
  (ref) => ParticipantsRepository(
    remoteDatabase: RemoteDatabase<Participant, Answer>(
      db: ref.read(databasePvdr),
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
