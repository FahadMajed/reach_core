import 'package:reach_core/core/core.dart';

mixin NamesParser {
  String parseNames(List names) {
    int i = 0;
    String parsedNames = "choose".tr;
    if (names.isNotEmpty) {
      parsedNames = "";
      for (String name in names) {
        i++;
        if (i <= 1 && name != names.last) {
          parsedNames += "$name, ";
        } else {
          if (name != names.last) {
            parsedNames += "$name, ";
          } else {
            parsedNames += name;
          }

          int remaining = names.length - i;
          if (remaining > 0) parsedNames += " +$remaining";
          break;
        }
      }
    }
    return parsedNames;
  }
}
