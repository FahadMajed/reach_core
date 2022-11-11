import 'package:flutter/foundation.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class ParticipantsRepositoryImpl implements ParticipantsRepository {
  ParticipantsRepositoryImpl({
    required RemoteDatabase<Participant, Answer> remoteDatabase,
  }) {
    _db = remoteDatabase;
  }

  late final RemoteDatabase<Participant, Answer> _db;

  @override
  Future<void> createParticipant(Participant participant) async {
    await _db.createDocument(participant, participant.participantId);
  }

  @override
  Future<Participant> getParticipant(String participantId) async {
    return await _db.getDocument(participantId);
  }

  @override
  Future<void> removeParticipant(String participantId) async {
    await _db.deleteDocument(participantId);
  }

  @override
  Future<void> updateParticipant(Participant participant) async {
    await _db.updateDocument(participant, participant.participantId);
  }

  @override
  Future<void> removeEnrollment(String id, String researchId) async =>
      await _db.updateFieldArrayRemove(id, 'currentEnrollments', [researchId]);

  @override
  Future<void> addEnrollment(String id, String researchId) async =>
      await _db.updateDocumentRaw(
        {
          'currentEnrollments': _db.arrayUnion([researchId]),
          'enrollmentHistory': _db.arrayUnion([researchId]),
        },
        id,
      );

  @override
  Future<void> addAnswer(
    String id,
    String researchId,
    Answer asnwer,
  ) async =>
      await _db.createSubdocument(
        parentId: id,
        subDocId: Formatter.formatTimeId(),
        data: asnwer.copyWith(
          researchId: researchId,
        ),
      );

  Future<void> markRejected(
    String participantId,
    String researchId,
  ) async =>
      await _db.updateFieldArrayUnion(
        participantId,
        'enrollmentHistory',
        [researchId],
      );

  @override
  @protected
  Future<List<Participant>> getRandomParticipants(int number) async =>
      await _db.getDocuments(number);

  Future<List<Answer>> getAnswers(String participantId) async {
    return await _db.getAllSubcollection(participantId);
  }

  @override
  Future<void> updateCriterion(
    String partId,
    Criterion? updatedCriterion,
  ) async {
    if (updatedCriterion != null) {
      await _db.updateField(
        partId,
        'criteria.${updatedCriterion.name}',
        criterionToMap(updatedCriterion),
      );
    }
  }
}

final partsRepoPvdr = Provider<ParticipantsRepository>(
  (ref) => ParticipantsRepositoryImpl(
    remoteDatabase: FirestoreRemoteDatabase<Participant, Answer>(
      db: ref.read(databasePvdr),
      collectionPath: "participants",
      fromMap: (snapshot, _) => snapshot.data() != null
          ? ParticipantMapper.fromMap(snapshot.data())
          : Participant.empty(),
      toMap: (p, _) => ParticipantMapper.toMap(p),
      subCollectionPath: "answers",
      subFromMap: (snapshot, _) => snapshot.data() != null
          ? Answer.fromMap(snapshot.data()!)
          : Answer.empty(),
      subToMap: (a, _) => a.toMap(),
    ),
  ),
);
