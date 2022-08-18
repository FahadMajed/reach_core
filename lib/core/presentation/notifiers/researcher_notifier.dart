import 'package:reach_auth/providers/auth_providers.dart';
import 'package:reach_core/core/core.dart';

class ResearcherNotifier extends StateNotifier<AsyncValue<Researcher>> {
  final String _userId;
  final ResearcherRepository _repository;

  ResearcherNotifier(this._repository, this._userId)
      : super(const AsyncLoading()) {
    if (_userId.isNotEmpty) {
      getResearcher(_userId);
    }
  }

  Future<void> getResearcher(String id) async {
    state = const AsyncLoading();
    final researcher = await _repository.getDocument(id);

    state = AsyncData(researcher);
  }

  Future<void> updateCurrentResearchs({
    String? researchId,
    Operation operation = Operation.add,
  }) async {
    late final Researcher researcher;

    switch (operation) {
      case Operation.remove:
        researcher = state.value!..currentResearchsIds.remove(researchId);
        break;
      case Operation.add:
        researcher = state.value!..currentResearchsIds.add(researchId);
        break;
      case Operation.clear:
        researcher = state.value!..currentResearchsIds.clear();
        break;
    }

    _updateState(currentResearchsIds: researcher.currentResearchsIds);
    await _updateData();
  }

  Future<void> createResearcher(Researcher researcher) async =>
      await _repository
          .createDocument(researcher)
          .then((r) => state = AsyncData(r));

  void _updateState(
          {String? id,
          String? name,
          String? imageUrl,
          String? bio,
          int? color,
          String? organization,
          String? city,
          List? currentResearchsIds,
          int? numberOfResearches}) =>
      state.value != null
          ? state = AsyncData(
              state.value!.copyWith(
                  researcherId: id,
                  city: city,
                  name: name,
                  defaultColor: color,
                  imageUrl: imageUrl,
                  numberOfResearches: numberOfResearches,
                  bio: bio,
                  organization: organization),
            )
          : state = AsyncData(
              Researcher(
                researcherId: id!,
                city: city!,
                name: name!,
                defaultColor: color!,
                imageUrl: imageUrl!,
                bio: bio!,
                organization: organization!,
                currentResearchsIds: [],
                numberOfResearches: 0,
              ),
            );

  Future<void> _updateData() async =>
      await _repository.updateDocument(state.value!);

  Future<void> updateProfile({
    String? city,
    String? bio,
    String? org,
    String? name,
  }) async {
    _updateState(
      name: name,
      bio: bio,
      city: city,
      organization: org,
    );

    await _updateData();
  }

  Future<void> updateImageUrl(String url) async {
    _updateState(
      imageUrl: url,
    );
    _updateData();
  }

  Future<void> endResearch(String researchId) async {
    _incrementNumberOfResearchs();

    await updateCurrentResearchs(
        researchId: researchId, operation: Operation.remove);
  }

  void _incrementNumberOfResearchs() async => _updateState(
        numberOfResearches: state.value!.numberOfResearches + 1,
      );
}

final researcherPvdr =
    StateNotifierProvider<ResearcherNotifier, AsyncValue<Researcher>>((ref) {
  final String userId = ref.watch(userPvdr).value?.uid ?? "";
  final repo = ref.read(researcherRepoPvdr);
  return ResearcherNotifier(repo, userId);
});
