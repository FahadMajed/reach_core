import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';

import '../translations/ar_sa.dart';
import '../translations/en_us.dart';

class TranslationService extends Translations {
  static const enLocal = Locale("en", "US");
  static const arLocal = Locale("ar", "US");

  static final Map locales = {"English": enLocal, "Arabic": arLocal};

  @override
  Map<String, Map<String, String>> get keys => {
        "en_US": en,
        "ar_US": ar..addAll(arResearcher),
      };

  static void changeLocale(String lang) => Get.updateLocale(locales[lang]);

  static bool isEnglish() => true;

  static String getFamily() => isEnglish() ? "SF-Pro" : "SF-Arabic";
}
