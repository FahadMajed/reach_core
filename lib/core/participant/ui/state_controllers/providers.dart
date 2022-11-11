import 'package:reach_core/core/core.dart';

final partStatePvdr =
    StateNotifierProvider<ParticipantStateController, AsyncValue<Participant?>>(
        (ref) => ParticipantStateController());

final partStateCtrlPvdr = Provider((ref) => ref.watch(partStatePvdr.notifier));
