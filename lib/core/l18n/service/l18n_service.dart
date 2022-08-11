import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import '../translations/en_US.dart';

import '../translations/ar_SA.dart';

class TranslationService extends Translations {
  static final enlocal = Locale("en", "SA");
  static final arlocal = Locale("ar", "SA");

  static final Map locales = {"English": enlocal, "Arabic": arlocal};

  @override
  Map<String, Map<String, String>> get keys => {
        "en_SA": en,
        "ar_SA": ar..addAll(arResearcher),
      };

  static void changeLocale(String lang) => Get.updateLocale(locales[lang]);

  static bool isEnglish() => Get.deviceLocale == enlocal;

  static String getFamily() => isEnglish() ? "SF-Pro" : "SF-Arabic";
}
