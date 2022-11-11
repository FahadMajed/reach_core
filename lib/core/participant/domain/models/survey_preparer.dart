import 'package:reach_core/core/core.dart';
import 'package:reach_research/research/domain/domain.dart';

///PREPARES SURVEY QUESTIONS BY COMPARING PARTICIPANT CRITERIA TO RESEARCH'S, IT ALSO
///ADDS THE CUSTOMIZED QUESTIONS TO THE STACK
class SurveyPreparer {
  final Participant participant;
  final Research research;

  late final Criteria _participantCriteria;
  late final Criteria _researchCriteria;
  late final List<CustomizedQuestion> _customizedQuestions;

  SurveyPreparer({
    required this.participant,
    required this.research,
  }) {
    _customizedQuestions = research.questions;
    _participantCriteria = participant.criteria;
    _researchCriteria = research.criteria;
    getQuestions();
  }

  List<Question> getQuestions() {
    final surveyQuestions = <Question>[];
    final questionableCriteria = _getQuestionableCriteria();

    surveyQuestions.addAll(questionableCriteria
        .map(
          (criterion) => CriterionQuestion(
            criterion: criterion,
          ),
        )
        .toList());
    surveyQuestions.addAll(_customizedQuestions);

    return surveyQuestions;
  }

  ///the criteria where participant "might be" not in, e.g. part is 27-32, research is 32-48, part could be 27 (out) or 32 (in), so
  ///we must include a question in the survey about whether he is from 32-48 or not
  List<Criterion> _getQuestionableCriteria() {
    final List<Criterion> questionableCriteria = [];
    for (Criterion researchCriterion in _researchCriteria.iterable) {
      if (researchCriterion is RangeCriterion) {
        bool isInRange =
            _isParticipantCriterionInResearchRange(researchCriterion);

        if (isInRange == false) {
          questionableCriteria.add(researchCriterion);
        }
      } else {
        //Value Criterion check
        bool isNotDetermined =
            _isParticipantValueCriterionNotDetermined(researchCriterion.name);

        if (isNotDetermined) {
          questionableCriteria.add(researchCriterion);
        }
      }
    }
    return questionableCriteria;
  }

  /// this method will not execute except participant might be logically eliglble,
  /// so if he is 22-25 and research is 26-30 the method does not have to verfiy that.
  /// check of one side fits, but the other is doubtful.
  /// [0] e.g. if research is: 24-28, and participant is: 25-29 (one side is in), the method
  /// will return "age" as missing
  /// [1] also if research is 25-28 and participant is 22-30
  /// [2] also if research is 25-30 and participant is 22-27
  /// [3] also if research is 25-30 and participant is 25-31
  /// [4] also if research is 25-30 and participant is 22-30
  ///
  /// will not return [age] if research is 25-30 and participant is 28-29
  bool _isParticipantCriterionInResearchRange(
      RangeCriterion reserachCriterion) {
    final participantCriterion =
        _participantCriteria.getRangeCriterionByName(reserachCriterion.name);

    return participantCriterion.isInRange(reserachCriterion);
  }

  bool _isParticipantValueCriterionNotDetermined(String name) {
    final participantCriterion =
        _participantCriteria.getValueCriterionByName(name);

    return participantCriterion.isNotDetermined;
  }
}
