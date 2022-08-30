import 'package:reach_research/domain/models/models.dart';

abstract class BaseParticipant {
  //CRUD +
  Future<void> removeEnrollment(String id, String researchId);
  Future<void> addAnswers(String id, String answersId, List<Answer> asnwers);
  Future<void> addEnrollment(String id, String researchId);
}
