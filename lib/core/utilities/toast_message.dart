import 'package:flutter/material.dart';
import 'package:reach_core/core/core.dart';

class Toast {
  static void success(
    String message, {
    bool pop = false,
    int times = 1,
    //TODO RENAME TO ONVISIBLE
    Function()? toggler,
  }) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
        backgroundColor: const Color.fromARGB(255, 168, 236, 170),
        content: Row(
          children: [
            Icon(
              Icons.check,
              color: onSuccess.color,
            ),
            Expanded(
              child: Text(
                message.tr,
                style: onSuccess,
              ),
            )
          ],
        ),
      ),
    );

    if (toggler != null) {
      toggler();
    }

    if (pop) {
      Get.close(times);
    }
  }

  static void fail(
    String message, {
    Function()? toggler,
    int times = 1,
    bool pop = false,
  }) {
    if (pop) {
      Get.close(times);
    }
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
        backgroundColor: const Color.fromARGB(255, 244, 134, 126),
        content: Row(
          children: [
            Icon(
              Icons.error,
              color: onFail.color,
            ),
            Expanded(
              child: Text(
                message.tr,
                style: onSuccess,
              ),
            )
          ],
        ),
      ),
    );
    if (toggler != null) {
      toggler();
    }
  }
}
