import 'package:flutter/material.dart';
import 'package:reach_core/core/core.dart';

class LabelIconText extends StatelessWidget {
  final String label;
  final IconData iconData;
  final String text;

  const LabelIconText({
    required this.label,
    required this.iconData,
    required this.text,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        sizedHeight24,
        Text(
          label,
          style: titleExtraLargeBold,
          textAlign: TextAlign.center,
        ),
        sizedHeight12,
        Icon(
          iconData,
          size: iconSize96,
        ),
        sizedHeight24,
        Text(
          text,
          style: descMed,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
