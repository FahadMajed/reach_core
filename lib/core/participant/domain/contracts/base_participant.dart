import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

abstract class ParticipantsRepository {
  Future<void> createParticipant(Participant participant);

  Future<Participant> getParticipant(String participantId);

  Future<void> removeParticipant(String participantId);

  Future<void> updateParticipant(Participant participant);
  //CRUD +
  Future<void> removeEnrollment(String id, String researchId);
  Future<void> addAnswer(
    String id,
    String answersId,
    Answer asnwer,
  );
  Future<void> addEnrollment(String id, String researchId);

  Future<List<Participant>> getRandomParticipants(int participantsNeeded);

  Future<void> updateCriterion(
    String partId,
    Criterion? updatedCriterion,
  );
}
