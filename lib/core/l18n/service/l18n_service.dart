import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';

import '../translations/ar_sa.dart';
import '../translations/en_us.dart';

class TranslationService extends Translations {
  static const enLocal = Locale(
    "en",
  );
  static const arLocal = Locale(
    "ar",
  );

  static final Map locales = {"English": enLocal, "Arabic": arLocal};

  @override
  Map<String, Map<String, String>> get keys => {
        "en_SA": en,
        "ar_SA": ar..addAll(arResearcher),
      };

  static void changeLocale(String lang) => Get.updateLocale(locales[lang]);

  static bool isEnglish() => Get.deviceLocale == enLocal;

  static String getFamily() => isEnglish() ? "SF-Pro" : "SF-Arabic";
}
