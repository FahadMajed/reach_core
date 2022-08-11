import 'package:flutter/material.dart';
import 'package:reach_core/core/core.dart';

class CupertinoBSContainer extends StatelessWidget {
  final Widget child;

  const CupertinoBSContainer({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: getDeviceWidth(context) * 0.8,
      color: Color(0xff737373),
      child: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: [
            Container(
              padding: padding20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              height: getDeviceWidth(context) * 0.6,
              child: child,
            )
          ],
        ),
      ),
    );
  }
}
