import 'package:reach_core/lib.dart';
import 'package:reach_research/research.dart';

class RedeemBenefits extends UseCase<Participant, RedeemBenefitsRequest> {
  final ParticipantsRepository participantsRepository;
  final EnrollmentsRepository enrollmentsRepository;
  final ResearchsRepository researchsRepository;
  final GroupsRepository groupsRepository;

  RedeemBenefits(
    this.participantsRepository,
    this.enrollmentsRepository,
    this.groupsRepository,
    this.researchsRepository,
  );

  @override
  Future<Participant> call(RedeemBenefitsRequest request) async {
    final enrollment = request.enrollment.markRedeemed();
    final participant = request.participant.removeEnrollment(enrollment.researchId);
    participantsRepository.updateParticipant(participant);
    if (enrollment.research!.isGroupResearch) {
      groupsRepository.markRedeemed(enrollment);
    } else {
      enrollmentsRepository.updateEnrollment(enrollment);
    }
    final updatedResearch = enrollment.research!.removeParticipant(participant.participantId);
    researchsRepository.updateResearch(updatedResearch);
    if (updatedResearch.enrolledIds.isEmpty) {
      researchsRepository.updateResearchState(updatedResearch.researchId, ResearchState.done);
    }

    return participant;
  }
}

class RedeemBenefitsRequest {
  final Participant participant;
  final Enrollment enrollment;

  RedeemBenefitsRequest(
    this.participant,
    this.enrollment,
  );
}

final redeemBenefitsPvdr = Provider<RedeemBenefits>((ref) => RedeemBenefits(
      ref.read(partsRepoPvdr),
      ref.read(enrollmentsRepoPvdr),
      ref.read(groupsRepoPvdr),
      ref.read(researchsRepoPvdr),
    ));
