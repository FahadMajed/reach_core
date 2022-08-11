import 'package:flutter/material.dart';
import 'package:reach_core/core/core.dart';

class DarkBlueContainer extends StatelessWidget {
  final List<Widget> widgets;
  final double innerPadding;
  final EdgeInsets outerPadding;

  final CrossAxisAlignment crossAxisAlignment;

  const DarkBlueContainer(this.widgets,
      {this.innerPadding = 8,
      this.outerPadding = EdgeInsets.zero,
      this.crossAxisAlignment = CrossAxisAlignment.start});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: outerPadding,
      child: Container(
        width: getDeviceWidth(context),
        decoration: BoxDecoration(
          color: coolGrey50,
          borderRadius: radius,
        ),
        child: Padding(
          padding: EdgeInsets.all(innerPadding),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: crossAxisAlignment,
              children: widgets),
        ),
      ),
    );
  }
}

class CenteredContainer extends StatelessWidget {
  final List<Widget> widgets;

  const CenteredContainer(
    this.widgets,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getDeviceWidth(context),
      constraints: BoxConstraints(maxHeight: getDeviceHeight(context) * 0.2),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widgets),
      ),
    );
  }
}
