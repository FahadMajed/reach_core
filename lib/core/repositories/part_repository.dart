// ignore_for_file: empty_catches

import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class ParticipantsRepository
    implements
        DatabaseRepository<Participant>,
        SubCollectionRepository<List<Answer>> {
  late final CollectionReference<Participant> collection;

  ParticipantsRepository(FirebaseFirestore database) {
    collection = database.collection("participants").withConverter<Participant>(
          fromFirestore: (snapshot, _) => snapshot.data() == null
              ? Participant.empty()
              : Participant(snapshot.data()!),
          toFirestore: (model, _) => model.toMap(),
        );
  }

  @override
  Future<Participant> getDocument(String id) =>
      collection.doc(id).get().then((doc) => doc.data() ?? Participant.empty());

  @override
  Future<Participant?> createDocument(Participant participant) async {
    try {
      await collection.doc(participant.participantId).set(participant);
      return participant;
    } catch (e) {}
    return null;
  }

  @override
  Future<void> createSubDocument(
          String id, String subDocId, List<Answer> data) =>
      collection
          .doc(id)
          .collection("answers")
          .doc(subDocId)
          .set({"answers": data.map((e) => e.toMap()).toList()});

  @override
  Future<void> updateDocument(Participant participant) async =>
      collection.doc(participant.participantId).update(participant.toMap());

  @override
  Future<void> deleteDocument(String id) async =>
      await collection.doc(id).delete();

  @override
  Future<List<Participant>> getDocuments(
    String clause, {
    bool defaultFlow = false,
  }) {
    throw UnimplementedError();
  }

  Future<List<Participant>> getLimitedDocuments(int limit) => collection
      .limit(limit)
      .get()
      .then((value) => value.docs.map((e) => e.data()).toList());

  @override
  Future<void> updateFieldArrayRemove(
      String id, String field, List remove) async {
    collection.doc(id).update({field: FieldValue.arrayRemove(remove)});
  }

  @override
  Future<void> updateFieldArrayUnion(String id, String field, List union) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateField(String docId, String field, data) {
    throw UnimplementedError();
  }
}

final partsRepoPvdr = Provider((ref) => ParticipantsRepository(
      ref.read(databaseProvider),
    ));
