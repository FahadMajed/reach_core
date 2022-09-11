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
      this.getResearcher();
    }
  }

  @protected
  Researcher get researcher => state.value!;

  Future<void> getResearcher() async {
    state = const AsyncLoading();
    await _getResearcher
        .call(
      GetResearcherParams(researcherId: _uid),
    )
        .then((researcher) => state = AsyncData(researcher), onError: (e) {
      researcherLoaded();
      state = AsyncError(e);
    });
  }

  Future<void> createResearcher(Researcher researcher) async {
    researcherLoading();
    await _createResearcher
        .call(
      CreateResearcherParams(researcher: researcher),
    )
        .then((researcher) => state = AsyncData(researcher), onError: (e) {
      researcherLoaded();
      state = AsyncError(e);
    });
    researcherLoaded();
  }

  Future<void> updateProfile({
    String? city,
    String? bio,
    String? org,
    String? name,
    String? imageUrl,
    List? chatsIds,
    List? researchsIds,
  }) async {
    researcherLoading();
    await _updateResearcher
        .call(
      UpdateResearcherParams(
        updatedResearcher: _copyStateWith(
          bio: bio,
          name: name,
          organization: org,
          imageUrl: imageUrl,
          city: city,
        ),
        chatsIds: chatsIds,
        researchsIds: researchsIds,
      ),
    )
        .then(
      (researcher) => state = AsyncData(researcher),
      onError: (e) {
        researcherLoaded();
        state = AsyncError(e);
      },
    );
    researcherLoaded();
  }

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

final RxBool isResearcherLoading = false.obs;

void researcherLoading() => isResearcherLoading.value = true;
Future<void> researcherLoaded() async => isResearcherLoading.value = false;
