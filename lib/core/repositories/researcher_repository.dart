import 'package:reach_core/core/core.dart';

class ResearcherRepository implements DatabaseRepository<Researcher> {
  late final CollectionReference<Researcher> _collection;

  ResearcherRepository(FirebaseFirestore database) {
    _collection = database.collection("researchers").withConverter<Researcher>(
        fromFirestore: (snapshot, _) => snapshot.data() == null
            ? Researcher.empty()
            : Researcher.fromFirestore(snapshot.data()!),
        toFirestore: (model, _) => model.toMap());
  }

  @override
  Future<Researcher> getDocument(String id) =>
      _collection.doc(id).get().then((doc) => doc.data() ?? Researcher.empty());

  @override
  Future<Researcher> createDocument(Researcher researcher) async {
    await _collection.doc(researcher.researcherId).set(researcher);

    return researcher;
  }

  @override
  Future<void> deleteDocument(String id) async =>
      await _collection.doc(id).delete();

  @override
  Future<List<Researcher>> getDocuments(
    String clause, {
    bool defaultFlow = false,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateDocument(Researcher researcher) =>
      _collection.doc(researcher.researcherId).update(researcher.toMap());

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

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final researcherRepoPvdr =
    Provider((ref) => ResearcherRepository(ref.read(databaseProvider)));
