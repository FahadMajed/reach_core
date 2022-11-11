import 'package:reach_core/core/core.dart';
import 'package:reach_research/research/domain/domain.dart';

///DATA STRUCTURE
class Survey {
  final Participant participant;
  final Research research;
  late final List<Question> questions;
  late final SurveyPreparer _preparer;

  int _currentQuestionIndex = 0;

  Survey({
    required this.participant,
    required this.research,
    List<Question>? questions,
  }) {
    _preparer = SurveyPreparer(
      participant: participant,
      research: research,
    );
    questions != null ? this.questions = questions : this.questions = _preparer.getQuestions();
  }

  Question get currentQuestion => questions[_currentQuestionIndex];
  int get questionsLength => questions.length;

  bool isLastQuestion(Question question) => questions.last == (question);

  void updateCurrentQuestion() {
    _currentQuestionIndex++;
  }

  bool isOnLastQuestion() => _currentQuestionIndex == questions.length - 1;

  @override
  String toString() {
    return 'Survey(participant: $participant, research: $research, questions: $questions, _preparer: $_preparer)';
  }

  Survey copyWith({
    List<Question>? questions,
    Participant? participant,
  }) =>
      Survey(
        research: research,
        participant: participant ?? this.participant,
        questions: questions,
      );

  factory Survey.empty() => Survey(
        participant: Participant.empty(),
        research: Research.empty(),
        questions: [],
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Survey &&
        other.participant == participant &&
        other.research == research &&
        other.questions == questions &&
        other._preparer == _preparer &&
        other._currentQuestionIndex == _currentQuestionIndex;
  }

  @override
  int get hashCode {
    return participant.hashCode ^
        research.hashCode ^
        questions.hashCode ^
        _preparer.hashCode ^
        _currentQuestionIndex.hashCode;
  }
}
