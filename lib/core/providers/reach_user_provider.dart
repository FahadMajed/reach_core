import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reach_auth/reach_auth.dart';
import 'package:reach_core/core/core.dart';

final researcherPvdr =
    StateNotifierProvider<ResearcherNotifier, Researcher>((ref) {
  final String userId = ref.watch(userPvdr).value?.uid ?? "";

  if (userId.isNotEmpty) return ResearcherNotifier(ref.read, userId);
  return ResearcherNotifier(ref.read, "");
});

final partPvdr = StateNotifierProvider<ParticipantNotifier, Participant>(
  (ref) {
    final watch = ref.watch;
    final String userId = watch(userPvdr).value?.uid ?? "";

    if (userId.isNotEmpty) {
      return ParticipantNotifier(
        userId: userId,
        reader: ref.read,
      );
    }
    return ParticipantNotifier(
      reader: ref.read,
      userId: userId,
    );
  },
);
