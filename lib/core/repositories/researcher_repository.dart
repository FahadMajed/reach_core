import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reach_core/core/core.dart';

class ResearcherRepository implements DatabaseRepository<Researcher> {
  final FirebaseFirestore _database;
  late CollectionReference<Researcher> collection;

  ResearcherRepository(this._database) {
    collection = _database.collection("researchers").withConverter<Researcher>(
        fromFirestore: (snapshot, _) =>
            Researcher.fromFirestore(snapshot.data()!),
        toFirestore: (model, _) => model.toMap());
  }

  @override
  Future<Researcher> getDocument(String id) =>
      collection.doc(id).get().then((doc) => doc.data() ?? Researcher.empty());

  @override
  Future<Researcher> createDocument(Researcher researcher) async {
    await collection.doc(researcher.researcherId).set(researcher);

    return researcher;
  }

  @override
  Future<void> deleteDocument(String id) async =>
      await collection.doc(id).delete();

  @override
  Future<List<Researcher>> getDocuments(
    String clause, {
    bool defaultFlow = false,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateDocument(Researcher researcher) =>
      collection.doc(researcher.researcherId).update(researcher.toMap());

  @override
  Future<void> updateField(String docId, String field, data) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateFieldArrayRemove(String docId, String field, List remove) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateFieldArrayUnion(String docId, String field, List union) {
    throw UnimplementedError();
  }
}

final researcherRepoPvdr =
    Provider((ref) => ResearcherRepository(ref.read(databaseProvider)));
