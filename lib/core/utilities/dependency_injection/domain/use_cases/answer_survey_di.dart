import 'package:reach_core/core/core.dart';
import 'package:reach_research/lib.dart';

final answerSurveyQuestionPvdr = Provider<AnswerSurveyQuestion>((ref) =>
    AnswerSurveyQuestion(ref.read(partsRepoPvdr), ref.read(markRejectedPvdr),
        ref.read(addParticipantToResearchPvdr)));
