import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reach_core/core/theme/theme.dart';
// add icon?

enum FilledButtonStyle { primary, accent }

class FilledButton extends StatelessWidget {
  const FilledButton({
    Key? key,
    required this.title,
    this.style = FilledButtonStyle.primary,
    this.isLoading = false,
    required this.onPressed,
  }) : super(key: key);
  final bool isLoading;
  final String title;
  final Function() onPressed;
  final FilledButtonStyle style;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: style == FilledButtonStyle.primary ? darkBlue : darkBlue100,
      borderRadius: radius,
      child: MaterialButton(
        onPressed: isLoading ? null : onPressed,
        minWidth: double.infinity,
        height: 55.0,
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(title.tr, style: style == FilledButtonStyle.primary ? filledButtonPrimary : filledButtonAccent),
      ),
    );
  }
}

typedef IntegerCallback = int Function();
