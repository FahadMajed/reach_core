import 'package:reach_core/core/core.dart';

class ParticipantMapper {
  static Participant fromMap(data) {
    return Participant(
        participantId: data['participantId'] ?? "",
        name: data['name'] ?? "",
        imageUrl: data['imageUrl'] ?? "",
        defaultColor: data['defaultColor'] ?? 0xFFFFFF,
        criteria: CriteriaMapper.fromMap(data['criteria'] ?? {}),
        currentEnrollments: data['currentEnrollments'] ?? [],
        enrollmentHistory: data['enrollmentHistory'] ?? [],
        walletBalance: 0);
  }

  static Map<String, dynamic> toMap(Participant participant) {
    return {
      'participantId': participant.participantId,
      'name': participant.name,
      'criteria': CriteriaMapper.toMap(participant.criteria),
      'imageUrl': participant.imageUrl,
      'defaultColor': participant.defaultColor,
      'currentEnrollments': participant.currentEnrollments,
      'enrollmentHistory': participant.enrollmentHistory,
      'walletBalance': participant.walletBalance,
    };
  }

  static Map<String, dynamic> toPartialMap(Participant participant) {
    return {
      'participantId': participant.participantId,
      'name': participant.name,
      'imageUrl': participant.imageUrl,
      'defaultColor': participant.defaultColor,
    };
  }

  static List<Participant> fromMapList(Map<String, dynamic> data) =>
      (data['participants'] as List).map(fromMap).toList();

  static List<Map<String, dynamic>> toMapList(List<Participant> elements) => elements.map(toPartialMap).toList();
}
