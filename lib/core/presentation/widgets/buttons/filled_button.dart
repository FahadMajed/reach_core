import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reach_core/core/theme/theme.dart';
// add icon?

enum FilledButtonStyle { Primary, Accent }

// ignore: must_be_immutable
class FilledButton extends StatelessWidget {
  FilledButton(
      {Key? key,
      required this.title,
      this.spinner,
      this.style = FilledButtonStyle.Primary,
      required this.onPressed})
      : super(key: key) {
    spinner = spinner ?? RxBool(false);
  }
  RxBool? spinner;
  final String title;
  final Function() onPressed;
  final FilledButtonStyle style;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Material(
        color: style == FilledButtonStyle.Primary ? darkBlue : darkBlue100,
        borderRadius: radius,
        child: MaterialButton(
          onPressed: spinner!.value ? null : onPressed,
          minWidth: double.infinity,
          height: 55.0,
          child: spinner!.value
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text(title.tr,
                  style: style == FilledButtonStyle.Primary
                      ? filledButtonPrimary
                      : filledButtonAccent),
        ),
      ),
    );
  }
}

typedef IntegerCallback = int Function();
