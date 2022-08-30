import 'package:reach_auth/providers/providers.dart';
import 'package:reach_chats/repositories/chats_repository.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

final researcherPvdr =
    StateNotifierProvider<ResearcherNotifier, AsyncValue<Researcher>>(
  (ref) {
    final String uid = ref.watch(userIdPvdr);
    final repo = ref.read(researcherRepoPvdr);
    final chatsRepo = ref.read(chatsRepoPvdr);
    final researchsRepo = ref.read(researchsRepoPvdr);

    return ResearcherNotifier(
      uid: uid,
      createResearcher: CreateResearcher(repo),
      getResearcher: GetResearcher(repo),
      updateResearcher: UpdateResearcher(
        researcherRepository: repo,
        researchsRepository: researchsRepo,
        chatsRepository: chatsRepo,
      ),
    );
  },
);
