import 'package:reach_core/core/core.dart';

class CreateParticipant extends UseCase<Participant, CreateParticipantParams> {
  final ParticipantsRepository repository;

  CreateParticipant(this.repository);

  @override
  Future<Participant> call(CreateParticipantParams params) async =>
      await repository
          .create(params.participant, params.participant.participantId)
          .then((value) => params.participant);
}

class CreateParticipantParams {
  final Participant participant;
  CreateParticipantParams({
    required this.participant,
  });
}
