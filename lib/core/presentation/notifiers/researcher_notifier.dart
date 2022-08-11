import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reach_core/core/core.dart';

class ResearcherNotifier extends StateNotifier<Researcher> {
  final Reader read;
  final String _userId;
  late ResearcherRepository repository;

  ResearcherNotifier(this.read, this._userId) : super(Researcher.empty()) {
    read(isResearcherLoadingPvdr.notifier).state = true;
    repository = read(researcherRepoPvdr);

    if (_userId.isNotEmpty) getResearcher(_userId);
  }

  Future<void> getResearcher(String id) async {
    final researcher = await repository.getDocument(id);
    if (mounted) {
      state = researcher;
      read(isResearcherLoadingPvdr.notifier).state = false;
    }
  }

  Future<void> updateCurrentResearchs(String researchId) async {
    final researcher = state;

    state = researcher..currentResearchsIds.remove(researchId);

    await repository.updateDocument(researcher);
  }

  Future<void> createResearcher() async =>
      await repository.createDocument(state).then((value) => state = value);

  void updateState({
    String? id,
    String? name,
    String? imageUrl,
    String? bio,
    String? organization,
    String? city,
  }) =>
      state = state.copyWith(
          researcherId: id,
          city: city,
          name: name,
          imageUrl: imageUrl,
          bio: bio,
          organization: organization);

  Future<void> updateData({
    String? id,
    String? name,
    String? imageUrl,
    String? bio,
    String? organization,
    String? city,
    List? currentResearchsIds,
    int? numberOfResearches,
  }) async {
    state = state.copyWith(
        researcherId: id,
        city: city,
        name: name,
        imageUrl: imageUrl,
        bio: bio,
        currentResearchsIds: currentResearchsIds,
        numberOfResearches: numberOfResearches,
        organization: organization);
    await repository.updateDocument(state);
  }
}

final isResearcherLoadingPvdr = StateProvider((ref) => false);
