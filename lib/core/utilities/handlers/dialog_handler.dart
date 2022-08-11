import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogHandler {
  static Future showAlertBox(
      {required String title,
      String desc = "",
      String okText = "OK",
      String cancelText = "Cancel",
      Function()? onOK,
      Function()? onCancel,
      bool isDestructive = false}) {
    if (Platform.isAndroid) {
      return showDialog(
        context: Get.overlayContext!,
        builder: (ctx) => AlertDialog(
          title: Text(title.tr),
          content: Text(desc.tr),
          actions: [
            if (onCancel != null)
              TextButton(
                child: Text(cancelText.tr),
                onPressed: () {
                  onCancel();
                },
              ),
            TextButton(
              child: Text(
                okText,
                style: isDestructive ? TextStyle(color: Colors.red) : null,
              ),
              onPressed: () {
                if (onOK != null) onOK();
              },
            ),
          ],
        ),
      );
    } else {
      return showCupertinoDialog(
        context: Get.overlayContext!,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(title.tr),
          content: Text(desc.tr),
          actions: [
            if (onCancel != null)
              CupertinoDialogAction(
                child: Text(cancelText.tr),
                onPressed: () {
                  if (onCancel != null) {
                    onCancel();
                  } else {
                    Get.close(1);
                  }
                },
              ),
            CupertinoDialogAction(
              child: Text(
                okText.tr,
                style: isDestructive ? TextStyle(color: Colors.red) : null,
              ),
              onPressed: () {
                if (onOK != null) {
                  onOK();
                } else {
                  Get.close(1);
                }
              },
            ),
          ],
        ),
      );
    }
  }
}
