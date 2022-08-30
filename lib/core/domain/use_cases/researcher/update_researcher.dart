import 'package:reach_chats/repositories/chats_repository.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class UpdateResearcher extends UseCase<Researcher, UpdateResearcherParams> {
  final ResearcherRepository researcherRepository;
  final ResearchsRepository researchsRepository;
  final ChatsRepository chatsRepository;
  UpdateResearcher({
    required this.researcherRepository,
    required this.researchsRepository,
    required this.chatsRepository,
  });

  @override
  Future<Researcher> call(UpdateResearcherParams params) async {
    final updatedResearcher = params.updatedResearcher;
    for (final chatId in params.chatsIds ?? []) {
      await chatsRepository.updateResearcher(chatId, updatedResearcher.partial);
    }
    for (final researchId in params.researchsIds ?? []) {
      await researchsRepository.updateResearcher(researchId, updatedResearcher);
    }

    return await researcherRepository
        .updateData(
          updatedResearcher,
          updatedResearcher.researcherId,
        )
        .then((_) => updatedResearcher);
  }
}

class UpdateResearcherParams {
  final Researcher updatedResearcher;
  final List? chatsIds;
  final List? researchsIds;

  UpdateResearcherParams({
    required this.updatedResearcher,
    this.chatsIds,
    this.researchsIds,
  });
}
