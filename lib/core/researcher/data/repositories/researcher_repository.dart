import 'package:reach_core/core/core.dart';

class ResearchersRepositoryImpl implements ResearchersRepository {
  ResearchersRepositoryImpl({
    required RemoteDatabase<Researcher, void> remoteDatabase,
  }) {
    _db = remoteDatabase;
  }

  late final RemoteDatabase<Researcher, void> _db;

  @override
  Future<void> createResearcher(Researcher researcher) async {
    await _db.createDocument(researcher, researcher.researcherId);
  }

  @override
  Future<Researcher> getResearcher(String researcherId) async {
    return await _db.getDocument(researcherId);
  }

  @override
  Future<void> removeResearcher(String researcherId) async {
    await _db.deleteDocument(researcherId);
  }

  @override
  Future<void> updateResearcher(Researcher researcher) async {
    await _db.updateDocument(researcher, researcher.researcherId);
  }

  @override
  Future<void> addResearch(String researcherId, String researchId) async =>
      await _db.updateFieldArrayUnion(
        researcherId,
        'currentResearchsIds',
        [researchId],
      );

  @override
  Future<void> endResearch(String researcherId, String researchId) async {
    await _db.updateDocumentRaw({
      'currentResearchsIds': _db.arrayUnion([researchId]),
      'numberOfResearches': _db.increment(1),
    }, researcherId);
  }

  @override
  Future<void> removeResearch(String researcherId, String researchId) async =>
      await _db.updateFieldArrayRemove(
        researcherId,
        'currentResearchsIds',
        [researchId],
      );
}

final researcherRepoPvdr = Provider<ResearchersRepository>(
  (ref) => ResearchersRepositoryImpl(
    remoteDatabase: FirestoreRemoteDatabase<Researcher, void>(
      db: ref.read(databasePvdr),
      collectionPath: "researchers",
      fromMap: (snapshot, _) => snapshot.data() != null
          ? ResearcherMapper.fromMap(snapshot.data() ?? {})
          : Researcher.empty(),
      toMap: (r, _) => ResearcherMapper.toMap(r),
    ),
  ),
);
