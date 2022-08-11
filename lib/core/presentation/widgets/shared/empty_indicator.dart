import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reach_core/core/core.dart';

class EmptyIndicator extends StatelessWidget {
  final String message;

  const EmptyIndicator(this.message);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding8,
        child: Text(
          message.tr,
          style: titleSmall,
        ),
      ),
    );
  }
}
