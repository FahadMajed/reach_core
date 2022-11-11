import 'package:reach_core/core/participant/domain/models/criteria.dart';
import 'package:reach_research/utils/mapper.dart';

class CriteriaMapper {
  static Criteria fromMap(Map criteria) {
    final Criteria result = {};
    for (final criterion in criteria.keys) {
      result[criterion] = criterionFromMap(criteria[criterion]);
    }
    return result;
  }

  static Map<String, dynamic> toMap(Criteria criteria) {
    final Map<String, dynamic> result = {};
    for (final criterion in criteria.keys) {
      result[criterion] = criterionToMap(criteria[criterion]!);
    }
    return result;
  }
}
