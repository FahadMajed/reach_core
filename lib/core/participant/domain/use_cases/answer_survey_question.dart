import 'package:reach_core/core/core.dart';
import 'package:reach_research/lib.dart';

class AnswerSurveyQuestion extends UseCase<AnswerSurveyQuestionResponse, AnswerSurveyQuestionRequest> {
  final ParticipantsRepository repository;
  final MarkRejected markRejected;
  final AddParticipantToResearch addParticipantToResearch;

  Participant? updatedParticipant;
  late EnrollmentStatus enrollmentStatus;
  late AnswerSurveyQuestionRequest _request;

  AnswerSurveyQuestion(
    this.repository,
    this.markRejected,
    this.addParticipantToResearch,
  );

  Survey get _survey => _request.survey;
  Question get _question => _survey.currentQuestion;
  Participant get _participant => _request.participant;
  String get _researchId => _research.researchId;
  bool get _response => _request.participantResponse;
  Research get _research => _survey.research;

  @override
  Future<AnswerSurveyQuestionResponse> call(AnswerSurveyQuestionRequest request) async {
    _request = request;

    if (_question is CriterionQuestion) {
      _updateCriterion();
    }
    if (_question is CustomizedQuestion) {
      _addAnswer();
    }

    _processEnrollmentStatus();

    return AnswerSurveyQuestionResponse(
      survey: _survey..updateCurrentQuestion(),
      updatedParticipant: updatedParticipant ?? _participant,
      enrollmentStatus: enrollmentStatus,
      enrollment: _getEnrollment(),
    );
  }

  Future<void> _updateCriterion() async {
    final criterionUpdater = CriterionUpdater(
      question: _question as CriterionQuestion,
      participant: _participant,
      participantResponse: _response,
    );

    criterionUpdater.update();

    final updatedCriterion = criterionUpdater.updatedCriterion;
    updatedParticipant = _participant.updateCriterion(updatedCriterion);
    repository.updateCriterion(
      _participant.participantId,
      updatedCriterion,
    );
  }

  void _addAnswer() async {
    repository.addAnswer(
      _participant.participantId,
      _researchId,
      Answer(
        myAnswer: _response,
        expectedAnswer: (_question as CustomizedQuestion).expectedAnswer,
        question: (_question as CustomizedQuestion).questionText,
      ),
    );
  }

  void _processEnrollmentStatus() async {
    final enrollmentStatusProcessor = EnrollmentStatusProcessor(
      question: _question,
      isLastQuestion: _survey.isLastQuestion(_question),
      participantResponse: _response,
    );
    enrollmentStatusProcessor.process();
    enrollmentStatus = enrollmentStatusProcessor.status;

    switch (enrollmentStatus) {
      case EnrollmentStatus.enrolled:
        return _addParticipantToResearch();

      case EnrollmentStatus.rejected:
        return _markParticipantRejected();
      default:
    }
  }

  Future<void> _addParticipantToResearch() async => addParticipantToResearch.call(AddParticipantToResearchRequest(
        participant: _participant,
        research: _research,
      ));

  Future<void> _markParticipantRejected() async => markRejected.call(MarkRejectedRequest(
        researchId: _researchId,
        participantId: _participant.participantId,
      ));

  Enrollment? _getEnrollment() => enrollmentStatus == EnrollmentStatus.enrolled
      ? Enrollment.create(
          (updatedParticipant ?? _participant).addEnrollment(_researchId),
          research: _research.addEnrollment(_participant.participantId),
          researchId: _researchId,
        )
      : null;
}

class AnswerSurveyQuestionRequest {
  final Survey survey;
  final Participant participant;
  final bool participantResponse;

  AnswerSurveyQuestionRequest({
    required this.survey,
    required this.participant,
    required this.participantResponse,
  });
}

class AnswerSurveyQuestionResponse {
  final Survey survey;
  final Participant updatedParticipant;
  final EnrollmentStatus enrollmentStatus;
  final Enrollment? enrollment;
  AnswerSurveyQuestionResponse({
    required this.survey,
    required this.updatedParticipant,
    required this.enrollmentStatus,
    this.enrollment,
  });
}
