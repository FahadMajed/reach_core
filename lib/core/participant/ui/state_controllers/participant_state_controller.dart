import 'package:reach_core/core/core.dart';

class ParticipantStateController extends AsyncStateControIIer<Participant> {
  Participant get participant => state.value!;
}
