import 'package:reach_core/core/core.dart';
import 'package:reach_research/research/research.dart';

class MarkRejected extends UseCase<void, MarkRejectedRequest> {
  final ResearchsRepository repository;

  MarkRejected(
    this.repository,
  );

  @override
  Future<void> call(MarkRejectedRequest request) async {
    repository.addParticipantToRejected(
      request.participantId,
      request.researchId,
    );
  }
}

class MarkRejectedRequest {
  final String researchId;
  final String participantId;

  MarkRejectedRequest({
    required this.researchId,
    required this.participantId,
  });
}

final markRejectedPvdr = Provider<MarkRejected>((ref) => MarkRejected(
      ref.read(researchsRepoPvdr),
    ));
