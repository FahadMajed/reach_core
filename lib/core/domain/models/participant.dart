import 'package:reach_research/research.dart';

import 'base_model.dart';

class Participant extends BaseModel<Participant> {
  Participant(Map<String, dynamic> jSON) : super(jSON);

  String get participantId => data['participantId'];

  String get name => data['name'];

  Map<String, Criterion>? get criteria => {
        for (final String criterion in data['criteria']?.keys ?? {})
          criterion: criterionFromMap(data['criteria'][criterion]),
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
        'criteria': criteriaEmptyStateRanges.map(
          (key, criterion) => MapEntry(
            key,
            criterionToMap(
              criterion,
            ),
          ),
        ),
        'imageUrl': "",
        'enrollmentHistory': const [],
        'currentEnrollments': const [],
        'name': "Participant",
        'walletBalance': 0,
        'missingCriteria': const []
      });

  @override
  Map<String, dynamic> toMap() => {
        ...data,
        "criteria": criteria!
            .map((key, criterion) => MapEntry(key, criterionToMap(criterion)))
      };

  @override
  List<Object> get props => [toMap()];

  ///returns sub-set of participants data, used for duplications
  Participant get partial => Participant(toPartialMap());
}
