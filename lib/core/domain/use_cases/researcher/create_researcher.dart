import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class CreateResearcher extends UseCase<Researcher, CreateResearcherParams> {
  final ResearcherRepository repository;

  CreateResearcher(this.repository);

  @override
  Future<Researcher> call(CreateResearcherParams params) async => repository
      .create(
        params.researcher,
        params.researcher.researcherId,
      )
      .then((_) => params.researcher);
}

class CreateResearcherParams {
  final Researcher researcher;
  CreateResearcherParams({
    required this.researcher,
  });
}
