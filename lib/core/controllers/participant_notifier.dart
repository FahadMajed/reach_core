import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class ParticipantNotifier extends StateNotifier<AsyncValue<Participant>> {
  late final String _uid;

  late final UpdateParticipant _updatePartcipant;

  late final GetParticipant _getParticipant;

  late final CreateParticipant _createParticipant;

  late final AddAnswers _addAnswers;

  ParticipantNotifier({
    required String uid,
    required UpdateParticipant updateParticipant,
    required GetParticipant getParticipant,
    required CreateParticipant createParticipant,
    required AddAnswers addAnswers,
  }) : super(const AsyncLoading()) {
    _uid = uid;
    _updatePartcipant = updateParticipant;
    _getParticipant = getParticipant;
    _createParticipant = createParticipant;
    _addAnswers = addAnswers;
    if (_uid.isNotEmpty) {
      this.getParticipant(_uid);
    }
  }

  Participant get _participant => state.value!;
  // List get _enrollmentHistory => _participant.enrollmentHistory;
  // List get _currentEnrollments => _participant.currentEnrollments;
  Map<String, Criterion> get criteria => _participant.criteria!;
  List get _missingCriteria => _participant.missingCriteria;

  Future<void> getParticipant(String _uid) async {
    state = const AsyncLoading();
    await _getParticipant
        .call(
          GetParticipantParams(participantId: _uid),
        )
        .then(
          (participant) => state = AsyncData(participant),
          onError: (e) => state = AsyncError(e),
        );
  }

  Future<void> updateProfile({
    String? name,
    Map<String, Criterion>? myCriteria,
    String? imageUrl,
    List? chatsIds,
    List? researchsIds,
  }) async =>
      await _updatePartcipant
          .call(UpdateParticipantParams(
            updatedParticipant: copyStateWith(
              name: name,
              criteria: myCriteria,
              imageUrl: imageUrl,
            ),
            researchsIds: researchsIds,
            chatsIds: chatsIds,
          ))
          .then(
            (participant) => state = AsyncData(participant),
            onError: (e) => state = AsyncError(e),
          );

  Future<void> insertAnswers(
    List<Answer> answers,
    String researchId,
  ) async =>
      await _addAnswers.call(
        AddAnswersParams(
          answers: answers,
          researchId: researchId,
          participantId: _uid,
        ),
      );

  Future<void> createParticipant(Participant participant) async =>
      _createParticipant
          .call(
            CreateParticipantParams(participant: participant),
          )
          .then(
            (participant) => state = AsyncData(participant),
            onError: (e) => state = AsyncError(e),
          );

  void setMissingCriteria(Map<String, Criterion> researchCriteria) {
    state = AsyncData(copyStateWith(missingCriteria: []));

    for (String criterionName in researchCriteria.keys) {
      if (researchCriteria[criterionName] is RangeCriterion) {
        final partiallyTrue = _inRangeCriterion(
          criterionName,
          researchCriteria[criterionName] as RangeCriterion,
        );

        if (partiallyTrue != null) {
          _missingCriteria.add(criterionName);
        }
      } else if ((criteria[criterionName] as ValueCriterion)
          .condition
          .isEmpty) {
        _missingCriteria.add(criterionName);
      }
    }

    state = AsyncData(copyStateWith(missingCriteria: _missingCriteria));
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
    final _criteria = _participant.criteria;

    final RangeCriterion myCriterion =
        _criteria![criterionName] as RangeCriterion;

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
    final Map<String, Criterion> _criteria = _participant.criteria!;
    if (currentCriterion is RangeCriterion) {
      _criteria.addAll(_compareBothSides(criterionName, currentCriterion));
    } else {
      _criteria[criterionName] = currentCriterion as ValueCriterion;
    }
    await _updatePartcipant
        .call(
          UpdateParticipantParams(
            updatedParticipant: copyStateWith(criteria: _criteria),
          ),
        )
        .then(
          (participant) => state = AsyncData(participant),
          onError: (e) => state = AsyncError(e),
        );
  }

  Map<String, Criterion> _compareBothSides(
    String criterionName,
    RangeCriterion criterion,
  ) {
    final _criteria = _participant.criteria;

    var criterionTemp = _criteria![criterionName] as RangeCriterion;

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
    final _criteria = _participant.criteria;

    bool isMatched = true;

    for (final researchCriterion in researchCriteria.values) {
      if (researchCriterion is ValueCriterion) {
        ValueCriterion myCriterion =
            _criteria![researchCriterion.name] as ValueCriterion;

        if (myCriterion.condition != researchCriterion.condition &&
            myCriterion.condition.isNotEmpty) {
          isMatched = false;
          break;
        }
      } else if (researchCriterion is RangeCriterion) {
        RangeCriterion myCriterion =
            _criteria![researchCriterion.name] as RangeCriterion;

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

  Participant copyStateWith({
    String? participantId,
    String? name,
    Map<String, Criterion>? criteria,
    String? imageUrl,
    int? defaultColor,
    List? enrolmentHistory,
    List? currentEnrollments,
    int? walletBalance,
    List? missingCriteria,
  }) =>
      _participant.copyWith(
        {
          'participantId': participantId,
          'name': name,
          'criteria': criteria?.map(
            (key, criterion) => MapEntry(
              key,
              criterionToMap(
                criterion,
              ),
            ),
          ),
          'imageUrl': imageUrl,
          'defaultColor': defaultColor,
          'enrolmentHistory': enrolmentHistory,
          'currentEnrollments': currentEnrollments,
          'missingCriteria': missingCriteria,
          'walletBalance': walletBalance
        },
      );
}
