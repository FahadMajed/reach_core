import 'package:reach_core/core/core.dart';

class MarkRejected extends UseCase<Participant, MarkRejectedParams> {
  final ParticipantsRepository repository;
  MarkRejected(this.repository);
  @override
  Future<Participant> call(MarkRejectedParams params) async {
    final part = params.participant;
    return await repository
        .markRejected(
          part.participantId,
          params.researchId,
        )
        .then((_) => part.copyWith({
              'enrollmentHistory': [
                ...part.enrollmentHistory,
                params.researchId
              ]
            }));
  }
}

class MarkRejectedParams {
  final String researchId;
  final Participant participant;

  MarkRejectedParams({
    required this.researchId,
    required this.participant,
  });
}
