import 'package:reach_core/core/core.dart';

class GetResearcher extends UseCase<Researcher, String> {
  final ResearchersRepository repository;
  GetResearcher(this.repository);
  @override
  Future<Researcher> call(id) async =>
      await repository.getResearcher(id).then((researcher) => researcher);
}

final getResearcherPvdr = Provider<GetResearcher>((ref) => GetResearcher(
      ref.read(researcherRepoPvdr),
    ));
