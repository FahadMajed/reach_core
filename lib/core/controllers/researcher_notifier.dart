import 'package:flutter/material.dart';
import 'package:reach_core/core/core.dart';

class ResearcherNotifier extends StateNotifier<AsyncValue<Researcher>> {
  late final String _uid;
  late final GetResearcher _getResearcher;
  late final CreateResearcher _createResearcher;
  late final UpdateResearcher _updateResearcher;

  ResearcherNotifier({
    required String uid,
    required GetResearcher getResearcher,
    required CreateResearcher createResearcher,
    required UpdateResearcher updateResearcher,
  }) : super(const AsyncLoading()) {
    _uid = uid;
    _getResearcher = getResearcher;
    _createResearcher = createResearcher;
    _updateResearcher = updateResearcher;

    if (_uid.isNotEmpty) {
      this.getResearcher(_uid);
    }
  }

  @protected
  Researcher get researcher => state.value!;

  Future<void> getResearcher(String id) async {
    state = const AsyncLoading();
    await _getResearcher
        .call(
          GetResearcherParams(researcherId: id),
        )
        .then(
          (researcher) => state = AsyncData(researcher),
          onError: (e) => state = AsyncError(e),
        );
  }

  Future<void> createResearcher(Researcher researcher) async =>
      await _createResearcher
          .call(
            CreateResearcherParams(researcher: researcher),
          )
          .then(
            (researcher) => state = AsyncData(researcher),
            onError: (e) => state = AsyncError(e),
          );

  Future<void> updateProfile({
    String? city,
    String? bio,
    String? org,
    String? name,
    String? imageUrl,
    List? chatsIds,
    List? researchsIds,
  }) async =>
      await _updateResearcher
          .call(
            UpdateResearcherParams(
              updatedResearcher: _copyStateWith(
                bio: bio,
                name: name,
                organization: org,
                imageUrl: imageUrl,
              ),
              chatsIds: chatsIds,
              researchsIds: researchsIds,
            ),
          )
          .then(
            (researcher) => state = AsyncData(researcher),
            onError: (e) => state = AsyncError(e),
          );

  Researcher _copyStateWith(
          {String? id,
          String? name,
          String? imageUrl,
          String? bio,
          int? color,
          String? organization,
          String? city,
          List? currentResearchsIds,
          int? numberOfResearches}) =>
      researcher.copyWith(
        {
          'researcherId': id,
          'city': city,
          'name': name,
          'defaultColor': color,
          'imageUrl': imageUrl,
          'numberOfResearches': numberOfResearches,
          'bio': bio,
          'organization': organization,
          'currentResearchsIds': currentResearchsIds,
        },
      );
}
