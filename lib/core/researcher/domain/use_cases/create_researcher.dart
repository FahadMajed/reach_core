import 'package:reach_core/core/core.dart';

class CreateResearcher extends UseCase<void, Researcher> {
  final ResearchersRepository repository;

  CreateResearcher(this.repository);

  @override
  Future<void> call(researcher) async => repository.createResearcher(researcher);
}

final createResearcherPvdr = Provider<CreateResearcher>((ref) => CreateResearcher(
      ref.read(researcherRepoPvdr),
    ));
