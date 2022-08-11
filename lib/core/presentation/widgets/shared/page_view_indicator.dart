import 'package:flutter/material.dart';
import 'package:reach_core/core/core.dart';

class PageViewIndicator extends StatelessWidget {
  final int numOfPages;
  final int currentPage;
  const PageViewIndicator({
    required this.numOfPages,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < numOfPages; i++)
            i == currentPage ? Indicator(true) : Indicator(false)
        ],
      );
}

class Indicator extends StatelessWidget {
  final bool isActive;

  const Indicator(this.isActive);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: 12.0,
      width: 12.0,
      decoration: BoxDecoration(
        color: isActive ? selectedColor : Colors.grey[400],
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
    );
  }
}
