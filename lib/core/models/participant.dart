import 'package:reach_research/research.dart';

class Participant {
  final String participantId;
  final String name;
  final Map<String, Criterion> myCriteria;
  final String imageUrl;
  final List<Answer> answers = [];
  final int defaultColor;
  final List<String> missingCriteria = [];

  final List<dynamic> enrolmentHistory; // List of Strings actually;
  final List<dynamic> currentEnrollments;

  final int walletBalance;
//TODO SWITCH THE LOGIC TO NOTIFIER!!!
  Participant({
    required this.participantId,
    required this.defaultColor,
    required this.myCriteria,
    required this.imageUrl,
    required this.enrolmentHistory,
    required this.currentEnrollments,
    required this.name,
    required this.walletBalance,
  });

  factory Participant.fromFirestore(Map data) {
    Map<String, Criterion> criteria = {};

    for (var key in data['criteria']?.keys ?? {}) {
      criteria[key] = criterionFromMap(data['criteria'][key]);
    }

    return Participant(
        participantId: data["participantId"] ?? '',
        name: data["name"] ?? '',
        myCriteria: criteria,
        imageUrl: data["imageUrl"] ?? '',
        enrolmentHistory: data["enrolmentHistory"] ?? [],
        currentEnrollments: data["currentEnrolments"] ?? [],
        defaultColor: data['defaultColor'] ?? 0xFF6076B8,
        walletBalance: data["walletBalance"] ?? 0);
  }

  void insertAnswer(String question, bool myAnswer, bool actualAnswer) =>
      answers.add(Answer(
          myAnswer: myAnswer, actualAnswer: actualAnswer, question: question));

  void addEnrolment(String researchId) {
    currentEnrollments.add(researchId);
    enrolmentHistory.add(researchId);
  }

  void removeEnrolment(String researchId) {
    //when research is done, we want to remove it
    currentEnrollments.remove(researchId);
  }

  Map<String, dynamic> toMap() {
    return {
      'participantId': participantId,
      'name': name,
      'criteria': myCriteria
          .map((name, criteria) => MapEntry(name, criterionToMap(criteria))),
      'imageUrl': imageUrl,
      'defaultColor': defaultColor,
      'enrolmentHistory': enrolmentHistory,
      'currentEnrolments': currentEnrollments,
      "walletBalance": walletBalance
    };
  }

  toPartialMap() {
    return {
      'participantId': participantId,
      'name': name,
      'imageUrl': imageUrl,
      'defaultColor': defaultColor,
    };
  }

  void setRequiredQuestions(Map<String, Criterion> criteria) {
    //CLEAR
    for (String criteriaName in criteria.keys) {
      if (criteria[criteriaName] is RangeCriterion) {
        _checkIfCriteriaInRange(
            criteriaName, criteria[criteriaName] as RangeCriterion);
      } else if ((myCriteria[criteriaName] as ValueCriterion)
          .condition
          .isEmpty) {
        missingCriteria.add(criteriaName);
      }
    }
  }

  void _checkIfCriteriaInRange(String criterionName, RangeCriterion criterion) {
    final RangeCriterion myCriterion =
        myCriteria[criterionName] as RangeCriterion;

    int myFrom = myCriterion.from;
    int myTo = myCriterion.to;

    if ((myFrom >= criterion.from && myTo <= criterion.to) == false) {
      missingCriteria.add(criterionName);
    }
  }

  // this method is to reduce the criteria range for the participant, e.g if i am 21-64. and i said yes to 48-50, my range will update
  void updateCriterion(String criterionName, Criterion currentCriterion) async {
    if (currentCriterion is RangeCriterion) {
      _compareBothSides(criterionName, currentCriterion);
    } else {
      myCriteria[criterionName] = currentCriterion as ValueCriterion;
    }
  }

  void _compareBothSides(String criterionName, RangeCriterion criterion) {
    RangeCriterion criterionTemp = myCriteria[criterionName] as RangeCriterion;

    int myFrom = criterionTemp.from;
    int myTo = criterionTemp.to;

    if (myFrom < criterion.from) {
      criterionTemp = criterionTemp.copyWith(from: criterion.from);
    }

    if (myTo > criterion.to) {
      criterionTemp = criterionTemp.copyWith(to: criterion.to);
    }

    myCriteria[criterionName] = criterionTemp;
  }

  void markRejected(String researchId) {
    enrolmentHistory.add(researchId);
  }

  bool isMatched(Map<String, Criterion> researchCriteria) {
    bool isMatched = true;

    for (final researchCriterion in researchCriteria.values) {
      if (researchCriterion is ValueCriterion) {
        ValueCriterion myCriterion =
            myCriteria[researchCriterion.name] as ValueCriterion;

        if (myCriterion.condition != researchCriterion.condition &&
            myCriterion.condition.isNotEmpty) {
          isMatched = false;
          break;
        }
      } else if (researchCriterion is RangeCriterion) {
        RangeCriterion myCriterion =
            myCriteria[researchCriterion.name] as RangeCriterion;

        if (myCriterion.from > researchCriterion.to) {
          isMatched = false;
          break;
        } else if (myCriterion.to < researchCriterion.from) {
          isMatched = false;
          break;
        }
      }
    }
    return isMatched;
  }

  @override
  String toString() {
    return 'Participant(participantId: $participantId, name: $name,  defaultColor: $defaultColor,)';
  }

  Participant copyWith({
    String? participantId,
    String? name,
    Map<String, Criterion>? myCriteria,
    String? imageUrl,
    int? defaultColor,
    List<dynamic>? enrolmentHistory,
    List<dynamic>? currentEnrollments,
    int? walletBalance,
  }) {
    return Participant(
        participantId: participantId ?? this.participantId,
        name: name ?? this.name,
        myCriteria: myCriteria ?? this.myCriteria,
        imageUrl: imageUrl ?? this.imageUrl,
        defaultColor: defaultColor ?? this.defaultColor,
        enrolmentHistory: enrolmentHistory ?? this.enrolmentHistory,
        currentEnrollments: currentEnrollments ?? this.currentEnrollments,
        walletBalance: walletBalance ?? this.walletBalance);
  }
}
