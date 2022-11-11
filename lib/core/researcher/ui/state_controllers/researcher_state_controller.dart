import 'package:reach_core/core/core.dart';

class ResearcherStateController extends AsyncStateControIIer<Researcher> {
  Researcher get researcher => state.value!;
}
