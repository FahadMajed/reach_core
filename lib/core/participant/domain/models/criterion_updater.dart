import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

/// UPDATES PARTICIPANT DATA, OR RETURNS PARTICIPANT [Answer] OBJECT, OR DO NOTHING
class CriterionUpdater {
  final Participant participant;
  final CriterionQuestion question;
  final bool participantResponse;

  Criterion? updatedCriterion;
  String _criterionName = "";
  CriterionUpdater({
    required this.question,
    required this.participant,
    required this.participantResponse,
  });

  ///Answers to Customized Questions

  void update() => participantResponse == true ? _onYes() : _onNo();

  void _onYes() {
    _criterionName = question.criterion.name;
    return _updateParticipantCriterion(question.criterion);
  }

  void _updateParticipantCriterion(Criterion researchCriterion) {
    if (researchCriterion is RangeCriterion) {
      _updateParticipantRangeCriterion(researchCriterion);
    } else if (researchCriterion is ValueCriterion) {
      _setUpdatedCriterion(researchCriterion);
    }
  }

  void _updateParticipantRangeCriterion(RangeCriterion researchCriterion) {
    final participantCriterion = participant.getRangeCriterion(_criterionName);
    final updatedCriterion = participantCriterion.compareTo(researchCriterion);

    _setUpdatedCriterion(updatedCriterion);
  }

  void _setUpdatedCriterion(Criterion updatedCriterion) =>
      this.updatedCriterion = updatedCriterion;

  void _onNo() {
    if (_criterionIsGender) {
      _setUpdatedCriterion(_getResearchGenderOpposite());
    }
  }

  bool get _criterionIsGender => question.criterion.name == "gender";

  ValueCriterion _getResearchGenderOpposite() {
    if (_researchGenderIsMale) {
      return const ValueCriterion.gender(condition: "Female");
    } else {
      return const ValueCriterion.gender(condition: "Male");
    }
  }

  bool get _researchGenderIsMale =>
      (question.criterion as ValueCriterion).isMale;
}
