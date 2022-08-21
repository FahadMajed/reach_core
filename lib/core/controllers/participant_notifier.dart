import 'package:reach_auth/providers/auth_providers.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class ParticipantNotifier extends StateNotifier<AsyncValue<Participant>> {
  final ParticipantsRepository _repository;
  final String _uid;

  ParticipantNotifier(
    this._repository,
    this._uid,
  ) : super(const AsyncLoading()) {
    if (_uid.isNotEmpty) {
      getParticipant(_uid);
    }
  }

  Participant get participant => state.value!;

  Future<void> getParticipant(String _uid) async {
    state = const AsyncLoading();
    final participant = await _repository.get(_uid) ?? Participant.empty();

    state = AsyncData(participant);
  }

  Future<void> updateProfile({
    String? name,
    Map<String, Criterion>? myCriteria,
    String? imageUrl,
  }) async {
    _updateState(
      name: name,
      criteria: myCriteria,
      imageUrl: imageUrl,
    );

    await _updateData();
  }

  Future<void> _updateData() async =>
      await _repository.updateData(participant, participant.participantId);

  void _updateState({
    String? participantId,
    String? name,
    Map<String, Criterion>? criteria,
    String? imageUrl,
    int? defaultColor,
    List? enrolmentHistory,
    List? currentEnrollments,
    int? walletBalance,
    List? missingCriteria,
  }) {
    state = AsyncData(
      participant.copyWith(
        {
          'participantId': participantId,
          'name': name,
          'criteria': criteria,
          'imageUrl': imageUrl,
          'defaultColor': defaultColor,
          'enrolmentHistory': enrolmentHistory,
          'currentEnrollments': currentEnrollments,
          'missingCriteria': missingCriteria,
          'walletBalance': walletBalance
        },
      ),
    );
  }

  Future<void> insertAnswers(
    bool insertAnswers,
    String researchId,
  ) async {
    _repository.addAnswers(
      participant.participantId,
      researchId,
      participant.answers,
    );
  }

  Future<void> createParticipant(Participant participant) async =>
      await _repository
          .create(participant, participant.participantId)
          .then((_) => state = AsyncData(participant));

  void setMissingCriteria(Map<String, Criterion> researchCriteria) {
    final _criteria = participant.criteria;
    final missingCriteria = participant.missingCriteria;
    missingCriteria.clear();

    for (String criterionName in researchCriteria.keys) {
      if (researchCriteria[criterionName] is RangeCriterion) {
        final partiallyTrue = _inRangeCriterion(
          criterionName,
          researchCriteria[criterionName] as RangeCriterion,
        );

        if (partiallyTrue != null) {
          missingCriteria.add(criterionName);
        }
      } else if ((_criteria[criterionName] as ValueCriterion)
          .condition
          .isEmpty) {
        missingCriteria.add(criterionName);
      }
    }

    _updateState(missingCriteria: missingCriteria);
  }

  /// this method will not execute except participant might be logically eliglble,
  /// so if he is 22-25 and research is 26-30 the method does not have to verfiy that.
  /// check of one side fits, but the other is doubtful.
  /// [0] e.g. if research is: 24-28, and participant is: 25-29 (one side is in), the method
  /// will return "age" as missing
  /// [1] also if research is 25-28 and participant is 22-30
  /// [2] also if research is 25-30 and participant is 22-27
  /// [3] also if research is 25-30 and participant is 25-31
  /// [4] also if research is 25-30 and participant is 22-30
  ///
  /// will not return [age] if research is 25-30 and participant is 28-29
  String? _inRangeCriterion(
    String criterionName,
    RangeCriterion reserachCriterion,
  ) {
    final _criteria = participant.criteria;

    final RangeCriterion myCriterion =
        _criteria[criterionName] as RangeCriterion;

    int myFrom = myCriterion.from;
    int myTo = myCriterion.to;

    if (myFrom < reserachCriterion.from || myTo > reserachCriterion.to) {
      return criterionName;
    }

    return null;
  }

  /// used to comply participant range with the [currentCriterion], this method
  /// will be triggered when a participant answers to a criterion question with yes
  /// the values of the criterion will be stored in [currentCriterion], and participant
  /// ranges will be changed accordingly
  ///
  /// case [1], [currentCriterion] is 45-60, participant is 42-59, participant will be: 45-59,
  ///
  /// case [2], [currentCriterion] is 45-60, participant is 42-61, participant will be: 45-60,
  ///
  /// case [3], [currentCriterion] is 45-60, participant is 48-61, participant will be: 48-60,
  ///
  /// case [4], [currentCriterion] is 45-60, participant is 42-60, participant will be: 45-60,
  ///
  /// case [5], [currentCriterion] is 45-60, participant is 45-63, participant will be: 45-60,
  ///
  /// case [6], [currentCriterion] is 45-60, participant is 47-59, participant will be: 47-59,
  ///
  /// case [7], [currentCriterion] is ValueCriterion, participant is empty, participant will be: [ValueCriterion.condition],

  Future<void> updateCriterion(
    String criterionName,
    Criterion currentCriterion,
  ) async {
    final Map<String, Criterion> _criteria = participant.criteria;
    if (currentCriterion is RangeCriterion) {
      _criteria.addAll(_compareBothSides(criterionName, currentCriterion));
    } else {
      _criteria[criterionName] = currentCriterion as ValueCriterion;
    }
    _updateState(criteria: _criteria);
    await _updateData();
  }

  Map<String, Criterion> _compareBothSides(
    String criterionName,
    RangeCriterion criterion,
  ) {
    final _criteria = participant.criteria;

    var criterionTemp = _criteria[criterionName] as RangeCriterion;

    int myFrom = criterionTemp.from;
    int myTo = criterionTemp.to;

    if (myFrom < criterion.from) {
      criterionTemp = criterionTemp.copyWith(from: criterion.from);
    }

    if (myTo > criterion.to) {
      criterionTemp = criterionTemp.copyWith(to: criterion.to);
    }

    _criteria[criterionName] = criterionTemp;
    return _criteria;
  }

  bool isMatched(Map<String, Criterion> researchCriteria) {
    final _criteria = participant.criteria;

    bool isMatched = true;

    for (final researchCriterion in researchCriteria.values) {
      if (researchCriterion is ValueCriterion) {
        ValueCriterion myCriterion =
            _criteria[researchCriterion.name] as ValueCriterion;

        if (myCriterion.condition != researchCriterion.condition &&
            myCriterion.condition.isNotEmpty) {
          isMatched = false;
          break;
        }
      } else if (researchCriterion is RangeCriterion) {
        RangeCriterion myCriterion =
            _criteria[researchCriterion.name] as RangeCriterion;

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

  Future<void> addEnrolment(String researchId) async {
    _updateState(
      currentEnrollments: participant.currentEnrollments..add(researchId),
      enrolmentHistory: participant.enrollmentHistory..add(researchId),
    );
    await _updateData();
  }

  Future<void> removeEnrollment(String researchId) async {
    _updateState(
      currentEnrollments: participant.currentEnrollments..remove(researchId),
    );
    await _updateData();
  }

  Future<void> rejectEnrollment(String researchId) async {
    _updateState(
      enrolmentHistory: participant.enrollmentHistory..remove(researchId),
    );
    await _updateData();
  }
}

final partPvdr =
    StateNotifierProvider<ParticipantNotifier, AsyncValue<Participant>>((ref) {
  final String userId = ref.watch(userPvdr).value?.uid ?? "";
  final repo = ref.read(partsRepoPvdr);
  return ParticipantNotifier(repo, userId);
});
