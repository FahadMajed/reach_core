import 'package:reach_core/core/core.dart';

class GetResearcher extends UseCase<Researcher, GetResearcherParams> {
  final ResearcherRepository repository;
  GetResearcher(this.repository);
  @override
  Future<Researcher> call(GetResearcherParams params) async => await repository
      .get(params.researcherId)
      .then((researcher) => researcher ?? Researcher.empty());
}

class GetResearcherParams {
  final String researcherId;
  GetResearcherParams({
    required this.researcherId,
  });
}
