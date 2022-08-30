import 'package:reach_auth/providers/providers.dart';
import 'package:reach_chats/repositories/chats_repository.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/data/repositories/enrollments_repository.dart';
import 'package:reach_research/research.dart';

final partPvdr =
    StateNotifierProvider<ParticipantNotifier, AsyncValue<Participant>>((ref) {
  final String uid = ref.watch(userIdPvdr);

  final repo = ref.read(partsRepoPvdr);
  final groupsRepo = ref.read(groupsRepoPvdr);
  final enrollmentsRepo = ref.read(enrollmentsRepoPvdr);
  final chatsRepo = ref.read(chatsRepoPvdr);

  return ParticipantNotifier(
    uid: uid,
    addAnswers: AddAnswers(repo),
    createParticipant: CreateParticipant(repo),
    getParticipant: GetParticipant(repo),
    updateParticipant: UpdateParticipant(
      chatsRepository: chatsRepo,
      participantsRepository: repo,
      groupsRepository: groupsRepo,
      enrollmentsRepository: enrollmentsRepo,
    ),
  );
});
