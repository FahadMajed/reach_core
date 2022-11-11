import 'package:reach_research/research/domain/domain.dart';

import 'criteria.dart';

///THIS CLASS IS CREATE DUE TO NOSQL INABILITY TO PERFORM COMPOUND QUERIES ON NUMBERS
///I.E. CHANNING isGreaterThan
class EligibilityDecider {
  final Criteria participantCriteria;
  final String participantId;
  final List<Research> researchs;
  EligibilityDecider({
    required this.participantCriteria,
    required this.participantId,
    required this.researchs,
  });

  List<Research> getResearchsWhereParticipantIsEligible() {
    List<Research> eligibleResearchs = [];

    for (final research in researchs) {
      if (_isParticipantEligible(research.criteria) && research.canAcceptParticipant(participantId)) {
        eligibleResearchs.add(research);
      }
    }

    return eligibleResearchs;
  }

  bool _isParticipantEligible(Criteria researchCriteria) {
    bool isEligible = true;

    for (final researchCriterion in researchCriteria.iterable) {
      switch (researchCriterion.runtimeType) {
        case RangeCriterion:
          isEligible = _compareRangeCriterion(researchCriterion as RangeCriterion);
          break;
        case ValueCriterion:
          isEligible = _compareValueCriterion(researchCriterion as ValueCriterion);

          break;
        default:
          throw Exception("Wrong Type: ${researchCriterion.runtimeType}");
      }
      if (isEligible == false) break;
    }

    return isEligible;
  }

  bool _compareRangeCriterion(RangeCriterion researchCriterion) {
    RangeCriterion partCriterion = participantCriteria.getRangeCriterionByName(researchCriterion.name);

    if (partCriterion.isOutOfRange(researchCriterion)) {
      return false;
    } else {
      return true;
    }
  }

  bool _compareValueCriterion(ValueCriterion researchCriterion) {
    ValueCriterion partCriterion = participantCriteria.getValueCriterionByName(researchCriterion.name);

    if (partCriterion.isNotEqualsTo(researchCriterion)) {
      return false;
    }
    return true;
  }
}
