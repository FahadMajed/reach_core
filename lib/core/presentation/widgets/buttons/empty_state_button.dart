import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_core/core/theme/theme.dart';

class EmptyStateButton extends StatelessWidget {
  final String text;
  final String buttonTitle;
  final Function() onPressed;
  final IconData iconData;

  const EmptyStateButton(
      {required this.text,
      required this.buttonTitle,
      required this.iconData,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        sizedHeight24,
        sizedHeight24,
        Text(
          text.tr,
          style: titleLargeBold.copyWith(color: Colors.black87),
          textAlign: TextAlign.center,
        ),
        sizedHeight24,
        Icon(
          iconData,
          size: iconSize48,
        ),
        sizedHeight24,
        FilledButton(
          title: buttonTitle.tr,
          onPressed: onPressed,
          style: FilledButtonStyle.Accent,
        )
      ],
    );
  }
}
