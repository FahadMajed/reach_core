import 'package:reach_core/core/models/base_model.dart';
import 'package:reach_research/research.dart';

class Participant extends BaseModel<Participant> {
  Participant(Map<String, dynamic> jSON) : super(jSON);

  String get participantId => data['participantId'];

  String get name => data['name'];

  Map<String, Criterion> get criteria => {
        for (final String criterion in data['criteria']!.keys)
          criterion: data['criteria'][criterion],
      };

  String get imageUrl => data['imageUrl'];

  List<Answer> get answers =>
      (data['answers'] as List).map((e) => Answer.fromMap(e)).toList();

  List get missingCriteria => data['missingCriteria'];

  int get defaultColor => data['defaultColor'];

  List get currentEnrollments => data['currentEnrollments'];

  List get enrollmentHistory => data['enrollmentHistory'];

  int get walletBalance => data['walletBalance'];

  toPartialMap() => {
        'participantId': participantId,
        'name': name,
        'imageUrl': imageUrl,
        'defaultColor': defaultColor,
      };

  @override
  Participant copyWith(Map<String, dynamic> newData) => Participant(
        {
          ...data,
          ...newData..removeWhere((key, value) => value == null),
        },
      );

  factory Participant.init(String uid) =>
      Participant.empty().copyWith({'participantId': uid});

  factory Participant.empty() => Participant({
        'participantId': '',
        'defaultColor': 0xFFFFFF,
        'criteria': criteriaEmptyStateRanges,
        'imageUrl': "",
        'enrollmentHistory': [],
        'currentEnrollments': [],
        'name': "Participant",
        'walletBalance': 0,
        'missingCriteria': []
      });

  @override
  Map<String, dynamic> toMap() => {
        ...data,
        "criteria": criteria
            .map((key, criterion) => MapEntry(key, criterionToMap(criterion)))
      };

  @override
  String toString() => toMap().toString();
}
