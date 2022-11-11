import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class Participant extends Equatable {
  final String participantId;

  final String name;

  final Criteria criteria;

  final String imageUrl;

  final int defaultColor;

  final List currentEnrollments;

  final List enrollmentHistory;

  final int walletBalance;

  const Participant({
    required this.participantId,
    required this.name,
    required this.criteria,
    required this.imageUrl,
    required this.defaultColor,
    required this.currentEnrollments,
    required this.enrollmentHistory,
    required this.walletBalance,
  });

  factory Participant.empty() => Participant(
        participantId: '1',
        defaultColor: ColorGenerator.getRandomColor(),
        criteria: criteriaEmptyStateRanges,
        imageUrl: "",
        enrollmentHistory: [],
        currentEnrollments: [],
        name: "Participant",
        walletBalance: 0,
      );
  factory Participant.init(String id) => Participant(
        participantId: id,
        defaultColor: ColorGenerator.getRandomColor(),
        criteria: criteriaEmptyStateRanges,
        imageUrl: "",
        enrollmentHistory: [],
        currentEnrollments: [],
        name: "Participant#${id.substring(0, 4)}",
        walletBalance: 0,
      );

  String get _getDefaultName => "Participant#${participantId.substring(0, 3)}";

  bool get nameIsNotSet => name == _getDefaultName;

  bool get isEnrolledToResearch => currentEnrollments.isNotEmpty;

  Participant copyWith({
    String? participantId,
    String? name,
    Criteria? criteria,
    String? imageUrl,
    int? defaultColor,
    List? currentEnrollments,
    List? enrollmentHistory,
    int? walletBalance,
  }) {
    return Participant(
      participantId: participantId ?? this.participantId,
      name: name ?? this.name,
      criteria: criteria ?? this.criteria,
      imageUrl: imageUrl ?? this.imageUrl,
      defaultColor: defaultColor ?? this.defaultColor,
      currentEnrollments: currentEnrollments ?? this.currentEnrollments,
      enrollmentHistory: enrollmentHistory ?? this.enrollmentHistory,
      walletBalance: walletBalance ?? this.walletBalance,
    );
  }

  RangeCriterion getRangeCriterion(String name) => criteria.getRangeCriterionByName(name);

  @override
  List<Object?> get props => [
        criteria,
        currentEnrollments,
        enrollmentHistory,
        name,
        imageUrl,
        walletBalance,
        participantId,
        defaultColor,
      ];

  Participant addEnrollment(String researchId) => copyWith(
        enrollmentHistory: [
          ...enrollmentHistory,
          researchId,
        ],
        currentEnrollments: [researchId],
      );

  Participant removeEnrollment(String researchId) => copyWith(
        currentEnrollments: currentEnrollments..remove(researchId),
      );

  factory Participant.initWithCriteria({
    RangeCriterion? age,
    RangeCriterion? height,
    RangeCriterion? weight,
    RangeCriterion? income,
    ValueCriterion? gender,
    ValueCriterion? nation,
  }) =>
      Participant.empty().copyWith(criteria: {
        "age": age ?? criteriaEmptyStateRanges["age"]!,
        "height": height ?? criteriaEmptyStateRanges["height"]!,
        "weight": weight ?? criteriaEmptyStateRanges["weight"]!,
        "income": income ?? criteriaEmptyStateRanges["income"]!,
        "gender": gender ?? criteriaEmptyStateRanges["gender"]!,
        "nation": nation ?? criteriaEmptyStateRanges["nation"]!,
      }, participantId: "111111");

  Participant updateCriterion(Criterion? updatedCriterion) => copyWith(criteria: {
        ...criteria,
        if (updatedCriterion != null) updatedCriterion.name: updatedCriterion,
      });
}
