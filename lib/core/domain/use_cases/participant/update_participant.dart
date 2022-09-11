import 'package:reach_chats/repositories/chats_repository.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class UpdateParticipant extends UseCase<Participant, UpdateParticipantParams> {
  final ParticipantsRepository participantsRepository;
  final GroupsRepository groupsRepository;
  final EnrollmentsRepository enrollmentsRepository;
  final ChatsRepository chatsRepository;

  UpdateParticipant({
    required this.participantsRepository,
    required this.groupsRepository,
    required this.enrollmentsRepository,
    required this.chatsRepository,
  });

  @override
  Future<Participant> call(UpdateParticipantParams params) async {
    final updatedParticipant = params.updatedParticipant;

    for (final researchId in params.researchsIds ?? []) {
      await groupsRepository.updateParticipant(
        researchId,
        updatedParticipant,
      );
      await enrollmentsRepository.updateParticipant(
        researchId,
        updatedParticipant,
      );
    }

    for (final chatId in params.chatsIds ?? []) {
      await chatsRepository.updateParticipant(
        chatId,
        updatedParticipant,
      );
    }

    return await participantsRepository
        .updateData(updatedParticipant, updatedParticipant.participantId)
        .then((_) => updatedParticipant);
  }
}

class UpdateParticipantParams {
  final Participant updatedParticipant;
  final List? chatsIds;
  final List? researchsIds;

  UpdateParticipantParams(
      {required this.updatedParticipant, this.chatsIds, this.researchsIds});
}
