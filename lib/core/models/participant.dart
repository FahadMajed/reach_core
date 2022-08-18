import 'package:reach_core/core/models/base_model.dart';
import 'package:reach_research/research.dart';

class Participant extends BaseModel<Participant> {
  Participant(Map<String, dynamic> jSON) : super(jSON);

  String get participantId => data['participantId'];

  String get name => data['name'];

  String get familyName => data['name'];

  Map<String, Criterion> get criteria => data['criteria'];

  String get imageUrl => data['imageUrl'];

  List<Answer> get answers => data['answers'];

  List<String> get missingCriteria => data['missingCriteria'];

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
          ...newData,
        },
      );

  factory Participant.init(String uid) =>
      Participant.empty().copyWith({'participantId': uid});

  factory Participant.empty() => Participant({
        'participantId': '',
        'defaultColor': 0xFFFFFF,
        'criteria': criteriaEmptyStateRanges,
        'imageUrl': "",
        'familyName': "",
        'enrolmentHistory': [],
        'currentEnrollments': [],
        'name': "Participant",
        'walletBalance': 0,
        'missingCriteria': []
      });

  @override
  String get primaryField => participantId;

  @override
  String toString() => toMap().toString();
}
