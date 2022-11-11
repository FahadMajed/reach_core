import 'package:reach_core/core/core.dart';

class GetParticipant extends UseCase<Participant, String> {
  final ParticipantsRepository repository;
  GetParticipant(this.repository);
  @override
  Future<Participant> call(participantId) async =>
      await repository.getParticipant(participantId).then((participant) => participant);
}

final getParticipantPvdr = Provider<GetParticipant>((ref) => GetParticipant(
      ref.read(partsRepoPvdr),
    ));
