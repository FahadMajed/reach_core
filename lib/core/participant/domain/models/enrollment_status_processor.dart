import 'package:reach_research/enrollments/domain/domain.dart';
import 'package:reach_research/research/domain/domain.dart';

class EnrollmentStatusProcessor {
  final Question question;
  final bool isLastQuestion;
  final bool participantResponse;

  EnrollmentStatus _enrollmentStatus = EnrollmentStatus.notDetermined;

  EnrollmentStatusProcessor(
      {required this.question,
      required this.isLastQuestion,
      required this.participantResponse});

  CustomizedQuestion get _customizedQuestion => question as CustomizedQuestion;
  EnrollmentStatus get status => _enrollmentStatus;

  void process() {
    participantResponse == true ? _onYes() : _onNo();
  }

  void _onYes() {
    if (question is CustomizedQuestion) {
      _checkIfCorrectAnswer(participantAnswer: true);
    }
    _processEnrollmentStatus();
  }

  void _onNo() {
    if (question is CriterionQuestion) {
      _rejectParticipant();
    } else if (question is CustomizedQuestion) {
      _checkIfCorrectAnswer(participantAnswer: false);
    }
    _processEnrollmentStatus();
  }

  void _processEnrollmentStatus() {
    if (isLastQuestion && _enrollmentStatus != EnrollmentStatus.rejected) {
      _enrollParticipant();
    }
  }

  void _rejectParticipant() {
    _enrollmentStatus = EnrollmentStatus.rejected;
  }

  void _enrollParticipant() {
    _enrollmentStatus = EnrollmentStatus.enrolled;
  }

  void _checkIfCorrectAnswer({required bool participantAnswer}) {
    if (participantAnswer != _customizedQuestion.expectedAnswer) {
      _rejectParticipant();
    }
  }
}
