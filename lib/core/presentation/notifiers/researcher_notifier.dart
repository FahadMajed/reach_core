import 'package:flutter/material.dart';
import 'package:reach_auth/providers/auth_providers.dart';
import 'package:reach_core/core/core.dart';

class ResearcherNotifier extends StateNotifier<AsyncValue<Researcher>> {
  final String _userId;
  final ResearcherRepository _repository;

  @protected
  Researcher get researcher => state.value!;

  ResearcherNotifier(this._repository, this._userId)
      : super(const AsyncLoading()) {
    if (_userId.isNotEmpty) {
      getResearcher(_userId);
    }
  }

  Future<void> getResearcher(String id) async {
    state = const AsyncLoading();
    final researcher = await _repository.get(id) ?? Researcher.empty();

    state = AsyncData(researcher);
  }

  Future<void> updateCurrentResearchs({
    String? researchId,
    Operation operation = Operation.add,
  }) async {
    late final Researcher researcher;

    switch (operation) {
      case Operation.remove:
        researcher = this.researcher..currentResearchsIds.remove(researchId);
        break;
      case Operation.add:
        researcher = this.researcher..currentResearchsIds.add(researchId);
        break;
      case Operation.clear:
        researcher = this.researcher..currentResearchsIds.clear();
        break;
    }

    _updateState(currentResearchsIds: researcher.currentResearchsIds);
    await _updateData();
  }

  Future<void> createResearcher(Researcher researcher) async =>
      await _repository
          .create(researcher, researcher.researcherId)
          .then((_) => state = AsyncData(researcher));

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
      state = AsyncData(
        researcher.copyWith(
          {
            'researcherId': id,
            'city': city,
            'name': name,
            'defaultColor': color,
            'imageUrl': imageUrl,
            'numberOfResearches': numberOfResearches,
            'bio': bio,
            'organization': organization
          },
        ),
      );

  Future<void> _updateData() async =>
      await _repository.updateData(researcher, researcher.researcherId);

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
        numberOfResearches: researcher.numberOfResearches + 1,
      );
}

final researcherPvdr =
    StateNotifierProvider<ResearcherNotifier, AsyncValue<Researcher>>((ref) {
  final String userId = ref.watch(userPvdr).value?.uid ?? "";
  final repo = ref.read(researcherRepoPvdr);
  return ResearcherNotifier(repo, userId);
});
