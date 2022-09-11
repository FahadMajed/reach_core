import 'package:reach_core/core/core.dart';

class GetParticipant extends UseCase<Participant, GetParticipantParams> {
  final ParticipantsRepository repository;
  GetParticipant(this.repository);
  @override
  Future<Participant> call(GetParticipantParams params) async =>
      await repository
          .get(params.participantId)
          .then((participant) => participant ?? Participant.empty());
}

class GetParticipantParams {
  final String participantId;

  GetParticipantParams({
    required this.participantId,
  });
}
