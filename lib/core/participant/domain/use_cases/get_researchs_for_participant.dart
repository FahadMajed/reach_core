import 'package:reach_core/core/core.dart';
import 'package:reach_research/research/research.dart';

class GetEligibleResearchsForParticipant extends UseCase<List<Research>, Participant> {
  final ResearchsRepository repository;
  GetEligibleResearchsForParticipant(this.repository);
  @override
  Future<List<Research>> call(Participant participant) async {
    final potentialResearchs = await repository.getResearchsForParticipant(participant.participantId);

    final eligibiltyDecider = EligibilityDecider(
      participantCriteria: participant.criteria,
      researchs: potentialResearchs,
      participantId: participant.participantId,
    );

    return eligibiltyDecider.getResearchsWhereParticipantIsEligible();
  }
}
