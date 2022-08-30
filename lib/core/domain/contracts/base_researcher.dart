abstract class BaseResearcher {
  Future<void> addResearch(String researcherId, String researchId);

  Future<void> endResearch(String researcherId, String researchId);
}
