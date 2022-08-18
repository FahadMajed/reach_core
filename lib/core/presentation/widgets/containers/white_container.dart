import 'package:flutter/material.dart';
import 'package:reach_core/core/core.dart';

class WhiteContainer extends StatelessWidget {
  final List<Widget> body;
  final EdgeInsets outerPadding;
  final EdgeInsets innerPadding;

  final CrossAxisAlignment alignment;
  final Function()? onTap;

  const WhiteContainer({
    required this.body,
    Key? key,
    this.onTap,
    this.outerPadding = padding8,
    this.innerPadding = padding8,
    this.alignment = CrossAxisAlignment.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => whiteContainer(context);

  Widget whiteContainer(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: outerPadding,
        child: Container(
          width: getDeviceWidth(context),
          decoration:
              const BoxDecoration(color: Colors.white, borderRadius: radius),
          child: Padding(
            padding: innerPadding,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: alignment,
                children: body),
          ),
        ),
      ),
    );
  }
}
