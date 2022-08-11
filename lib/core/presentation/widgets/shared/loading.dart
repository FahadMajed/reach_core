import 'package:flutter/material.dart';
import 'package:reach_core/core/core.dart';

class Loading extends StatelessWidget {
  final Color color;
  final double? value;

  const Loading({this.color = darkBlue300, this.value});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: padding16,
        decoration: BoxDecoration(
          borderRadius: radius,
        ),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
          value: value,
        ),
      ),
    );
  }
}
