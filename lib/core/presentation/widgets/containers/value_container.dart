import 'package:flutter/material.dart';
import 'package:reach_core/core/core.dart';

// ignore: must_be_immutable
class ValueContainer extends StatelessWidget {
  final Function()? onPressed;
  final Function()? onLongPress;
  final String value;
  late bool addSpacer;
  late IconData iconData;

  ValueContainer({this.onPressed, required this.value, this.onLongPress}) {
    addSpacer = false;
  }

  ValueContainer.arrowRight(
      {this.onPressed, required this.value, this.onLongPress}) {
    addSpacer = true;
    iconData = Icons.arrow_forward_ios;
  }

  ValueContainer.edit({this.onPressed, required this.value, this.onLongPress}) {
    addSpacer = true;
    iconData = Icons.edit;
  }

  ValueContainer.delete(
      {this.onPressed, required this.value, this.onLongPress}) {
    addSpacer = true;
    iconData = Icons.highlight_off;
  }

  ValueContainer.arrowDown(
      {this.onPressed, required this.value, this.onLongPress}) {
    addSpacer = false;
    iconData = Icons.arrow_drop_down;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed!(),
      onLongPress: () => onLongPress!(),
      child: BorderedContainer(
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: TranslationService.isEnglish() ? 8 : 0,
                right: TranslationService.isEnglish() ? 0 : 8,
              ),
              child: Text(
                value,
                style: descMedBlack,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (addSpacer) Spacer(),
            Icon(iconData),
            sizedWidth8
          ],
        ),
      ),
    );
  }
}
