import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class AddAnswers extends UseCase<void, AddAnswersParams> {
  final ParticipantsRepository repository;

  AddAnswers(this.repository);

  @override
  Future<void> call(AddAnswersParams params) async => await repository
      .addAnswers(params.participantId, params.researchId, params.answers);
}

class AddAnswersParams {
  final List<Answer> answers;
  final String researchId;
  final String participantId;

  AddAnswersParams({
    required this.answers,
    required this.researchId,
    required this.participantId,
  });
}
