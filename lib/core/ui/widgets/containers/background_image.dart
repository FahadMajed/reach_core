import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  final List<Widget> children;
  final String relativePath;

  const BackgroundImage({
    Key? key,
    required this.relativePath,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/images/$relativePath",
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomLeft,
          ),
        ),
        Column(children: children)
      ],
    );
  }
}
