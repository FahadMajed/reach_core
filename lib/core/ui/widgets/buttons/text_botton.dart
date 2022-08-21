import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reach_core/core/theme/theme.dart';

class TextBotton extends StatelessWidget {
  final String title;
  final Function() onPressed;

  const TextBotton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        title.tr,
        style: textButton,
      ),
    );
  }
}
