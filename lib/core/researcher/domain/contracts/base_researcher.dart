import 'package:reach_core/core/core.dart';

abstract class ResearchersRepository {
  Future<void> createResearcher(Researcher researcher);

  Future<Researcher> getResearcher(String researcherId);

  Future<void> removeResearcher(String researcherId);

  Future<void> updateResearcher(Researcher researcher);

  Future<void> addResearch(String researcherId, String researchId);

  Future<void> endResearch(String researcherId, String researchId);

  Future<void> removeResearch(String researcherId, String researchId);
}
