import 'package:reach_core/core/core.dart';
import 'package:reach_research/research/data/data.dart';

final getEligibleResearchsForParticipantPvdr =
    Provider<GetEligibleResearchsForParticipant>(
        (ref) => GetEligibleResearchsForParticipant(
              ref.read(researchsRepoPvdr),
            ));
