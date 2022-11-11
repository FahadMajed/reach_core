import 'package:reach_research/research/research.dart';

// class Criteriax {
//   late final Map<String, Criterion> _criteria;

//   Criteria(Map<String, Criterion> criteria) {
//     _criteria = criteria;
//   }

//   factory Criteria.fromMap(Map<String, dynamic> data) {
//     return Criteria(
//         data.map((key, value) => MapEntry(key, criterionFromMap(data))));
//   }

//   List<Criterion> get iterable => _criteria.values.toList();

//   RangeCriterion get age => _criteria['age'] as RangeCriterion;
//   RangeCriterion get height => _criteria['height'] as RangeCriterion;
//   RangeCriterion get weight => _criteria['weight'] as RangeCriterion;
//   RangeCriterion get income => _criteria['income'] as RangeCriterion;
//   ValueCriterion get gender => _criteria['gender'] as ValueCriterion;
//   ValueCriterion get nation => _criteria['nation'] as ValueCriterion;

//   Criteria updateParticipantCriterion(Criterion researchCriterion) {
//     if (researchCriterion is RangeCriterion) {
//       final rangeCriterion = _updateRange(researchCriterion);
//       return _copyWith(rangeCriterion);
//     } else {
//       return _copyWith(researchCriterion);
//     }
//   }

//   RangeCriterion _updateRange(
//     RangeCriterion researchCriterion,
//   ) {
//     RangeCriterion participantCriterion =
//         _criteria[researchCriterion.name] as RangeCriterion;

//     participantCriterion = participantCriterion.compareTo(researchCriterion);

//     return participantCriterion;
//   }

//   Criteria _copyWith(Criterion updatedCriterion) {
//     return Criteria(
//       {
//         for (final criterion in iterable)
//           if (criterion.name == updatedCriterion.name)
//             updatedCriterion.name: updatedCriterion
//           else
//             criterion.name: criterion
//       },
//     );
//   }

//   ValueCriterion getValueCriterionByName(String name) {
//     try {
//       return _criteria[name] as ValueCriterion;
//     } catch (e) {
//       throw Exception("Criteria Not Found: $name");
//     }
//   }

//   RangeCriterion getRangeCriterionByName(String name) {
//     try {
//       return _criteria[name] as RangeCriterion;
//     } catch (e) {
//       throw Exception("Criteria Not Found: $name");
//     }
//   }
// }

// enum CriteriaOptions { age, height, weight, income, gender, nation }

typedef Criteria = Map<String, Criterion>;

extension CriteriaX on Criteria {
  ValueCriterion getValueCriterionByName(String name) {
    return this[name] as ValueCriterion;
  }

  RangeCriterion getRangeCriterionByName(String name) {
    return this[name] as RangeCriterion;
  }

  Iterable<Criterion> get iterable => values;

  RangeCriterion get age => this['age'] as RangeCriterion;
  RangeCriterion get height => this['height'] as RangeCriterion;
  RangeCriterion get weight => this['weight'] as RangeCriterion;
  RangeCriterion get income => this['income'] as RangeCriterion;
  ValueCriterion get gender => this['gender'] as ValueCriterion;
  ValueCriterion get nation => this['nation'] as ValueCriterion;

  bool valueCriterionIsNotDetermined(String name) {
    final criterion = getValueCriterionByName(name);
    return criterion.condition.isEmpty;
  }
}
