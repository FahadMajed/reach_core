import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_core/core/theme/theme.dart';

class BottomButton extends StatelessWidget {
  final Function() onPressed;
  final Function()? fallBack;
  final bool isActive;
  final String title;
  final double? height;

  const BottomButton({
    Key? key,
    required this.onPressed,
    this.fallBack,
    this.title = 'cont',
    this.height,
    this.isActive = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = getDeviceHeight(context);
    return Container(
      color: isActive ? darkBlue : Colors.grey,
      width: double.infinity,
      height: this.height ?? height > 750 ? height * 0.09 : 60,
      child: TextButton(
        onPressed: isActive
            ? onPressed
            : () {
                fallBack!();
              },
        child: Text(
          title.tr,
          style: buttomButton,
        ),
      ),
    );
  }
}
