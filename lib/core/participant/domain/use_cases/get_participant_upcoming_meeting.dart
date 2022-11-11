import 'package:reach_core/lib.dart';
import 'package:reach_research/research.dart';

class GetParticipantUpcomingMeetings extends UseCase<Meeting?, GetParticipantUpcomingMeetingsRequest> {
  final ResearchsRepository repository;
  GetParticipantUpcomingMeetings(this.repository);
  @override
  Future<Meeting?> call(GetParticipantUpcomingMeetingsRequest request) async {
    final meeting = await repository.getUpcomingParticipantMeeting(
      request.participantId,
      request.researchId,
    );

    return meeting;
  }
}

class GetParticipantUpcomingMeetingsRequest {
  final String researchId;
  final String participantId;
  GetParticipantUpcomingMeetingsRequest({
    required this.researchId,
    required this.participantId,
  });
}

final getParticipantUpcomingMeetingPvdr =
    Provider<GetParticipantUpcomingMeetings>((ref) => GetParticipantUpcomingMeetings(
          ref.read(researchsRepoPvdr),
        ));
