import 'package:reach_core/core/core.dart';

final researcherStatePvdr =
    StateNotifierProvider<ResearcherStateController, AsyncValue<Researcher>>(
        (ref) => ResearcherStateController());

final researcherStateCtrlPvdr =
    Provider((ref) => ref.watch(researcherStatePvdr.notifier));
