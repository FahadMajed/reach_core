//M is the entity that the presenter handles
import 'package:reach_core/core/core.dart';

///responsible for setting up and  changing the view model state.
abstract class Presenter<V> {
  V presentViewModel();
}

///responsible for setting up and  changing the view model state.
