import 'package:reach_core/core/core.dart';

import '../../../../lib.dart';

class CreateParticipant extends UseCase<Participant, Participant> {
  final ParticipantsRepository repository;

  CreateParticipant(this.repository);

  @override
  Future<Participant> call(Participant participant) async =>
      await repository.createParticipant(participant).then((value) => participant);
}

final createParticipantPvdr = Provider<CreateParticipant>((ref) => CreateParticipant(
      ref.read(partsRepoPvdr),
    ));
