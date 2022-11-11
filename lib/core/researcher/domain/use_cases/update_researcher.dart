import 'package:reach_chats/chats.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class UpdateResearcher extends UseCase<Researcher, UpdateResearcherRequest> {
  final ResearchersRepository researcherRepository;
  final ResearchsRepository researchsRepository;
  final ChatsRepository chatsRepository;
  UpdateResearcher({
    required this.researcherRepository,
    required this.researchsRepository,
    required this.chatsRepository,
  });

  @override
  Future<Researcher> call(UpdateResearcherRequest request) async {
    final updatedResearcher = request.updatedResearcher;
    for (final chatId in request.chatsIds ?? []) {
      chatsRepository.updateResearcher(chatId, updatedResearcher);
    }
    for (final researchId in updatedResearcher.currentResearchsIds) {
      researchsRepository.updateResearcher(researchId, updatedResearcher);
    }
    researcherRepository.updateResearcher(updatedResearcher);

    return updatedResearcher;
  }
}

class UpdateResearcherRequest {
  final Researcher updatedResearcher;
  final List? chatsIds;

  UpdateResearcherRequest({
    required this.updatedResearcher,
    this.chatsIds,
  });
}

final updateResearcherPvdr = Provider<UpdateResearcher>(
  (ref) => UpdateResearcher(
    researcherRepository: ref.read(researcherRepoPvdr),
    chatsRepository: ref.read(chatsRepoPvdr),
    researchsRepository: ref.read(researchsRepoPvdr),
  ),
);
