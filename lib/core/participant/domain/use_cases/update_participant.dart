import 'dart:async';

import 'package:reach_chats/chats.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class UpdateParticipant extends UseCase<Participant, UpdateParticipantRequest> {
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
  Future<Participant> call(UpdateParticipantRequest request) async {
    final updatedParticipant = request.updatedParticipant;
    final enrollment = request.enrollment;
    if (enrollment != null) {
      if (enrollment.research!.isGroupResearch) {
        groupsRepository.updateParticipant(
          enrollment.groupId,
          updatedParticipant,
        );
      } else {
        enrollmentsRepository.updateParticipant(
          enrollment.researchId,
          updatedParticipant,
        );
      }
    }

    for (final chatId in request.chatsIds ?? []) {
      chatsRepository.updateParticipant(
        chatId,
        updatedParticipant,
      );
    }

    return await participantsRepository.updateParticipant(updatedParticipant).then((_) => updatedParticipant);
  }
}

class UpdateParticipantRequest {
  final Participant updatedParticipant;
  final Enrollment? enrollment;
  final List? chatsIds;

  UpdateParticipantRequest({
    required this.updatedParticipant,
    this.enrollment,
    this.chatsIds,
  });
}

final updateParticipantPvdr = Provider<UpdateParticipant>((ref) => UpdateParticipant(
      participantsRepository: ref.read(partsRepoPvdr),
      chatsRepository: ref.read(chatsRepoPvdr),
      enrollmentsRepository: ref.read(enrollmentsRepoPvdr),
      groupsRepository: ref.read(groupsRepoPvdr),
    ));
