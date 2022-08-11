import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class ParticipantNotifier extends StateNotifier<Participant> {
  final Reader reader;
  final String userId;
  late ParticipantsRepository repository;

  ParticipantNotifier({
    required this.reader,
    required this.userId,
  }) : super(Participant.fromFirestore({})) {
    repository = reader(partsRepoPvdr);
    if (userId.isNotEmpty) {
      getParticipant();
    }
  }

  Future<void> getParticipant() async {
    final participant = await repository.getDocument(userId);
    state = participant;
  }

  Future<void> updateProfile(Participant participant) async {
    state = participant;
    await repository.updateDocument(participant);
  }

  Future<void> insertAnswers(
    bool insertAnswers,
    String researchId,
  ) async {
    final participant = state;

    repository.createSubDocument(
      participant.participantId,
      researchId,
      participant.answers,
    );
  }

  Future<void> setParticipant(String uid) async {
    final participant = Participant(
      currentEnrollments: [],
      enrolmentHistory: [],
      imageUrl: "",
      participantId: uid,
      walletBalance: 0,
      name: 'Participant#${uid.substring(0, 4)}',
      myCriteria: criteriaEmptyStateRanges,
      defaultColor: ColorGenerator.getRandomColor().value,
    );
    await repository.createDocument(participant);
    if (mounted) state = participant;
  }

  void updateCriteria(Map<String, Criterion> updatedCriteria) =>
      state = state.copyWith(myCriteria: updatedCriteria);

  void setRequiredQuestions(Map<String, Criterion> criteria) =>
      state.setRequiredQuestions(criteria);

  void addEnrolment(String researchId) {
    state = state..addEnrolment(researchId);

    updateProfile(state);
  }

  void markRejected(String researchId) {
    state = state..enrolmentHistory.add(researchId);

    updateProfile(state);
  }
}
