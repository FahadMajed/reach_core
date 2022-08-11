import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reach_core/core/core.dart';

enum IconLabelStyle { Med, Small, Large, MedBold, SmallBold, LargeBold }

final Map<IconLabelStyle, TextStyle> iconLabels = {
  IconLabelStyle.Med: iconLabelMid,
  IconLabelStyle.Small: iconLabelSmall,
  IconLabelStyle.Large: iconLabelLarge,
  IconLabelStyle.MedBold: iconLabelMidBoldDark,
  IconLabelStyle.SmallBold: iconLabelSmallBold,
  IconLabelStyle.LargeBold: iconLabelLargeBold
};

class IconWithText extends StatelessWidget {
  final Icon icon;

  final String text;

  final Axis direction;
  final IconLabelStyle? style;

  const IconWithText({
    required this.icon,
    required this.text,
    this.style,
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: direction,
      children: [
        icon,
        SizedBox(
          height: direction == Axis.vertical ? 4 : 0,
          width: direction == Axis.vertical ? 0 : 4,
        ),
        Text(
          text.tr,
          style: style == null ? iconLabelSmall : iconLabels[style],
        ),
      ],
    );
  }
}

class IconWithRichText extends StatelessWidget {
  final Icon icon;

  final RichText richText;

  final Axis direction;
  final TextStyle? style;

  const IconWithRichText({
    required this.icon,
    required this.richText,
    this.style,
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: direction,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        SizedBox(
          height: direction == Axis.vertical ? 4 : 0,
          width: direction == Axis.vertical ? 0 : 4,
        ),
        richText,
      ],
    );
  }
}
