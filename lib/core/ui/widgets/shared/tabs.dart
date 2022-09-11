import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reach_core/core/core.dart';

class TabsBar extends StatelessWidget {
  final List<String> tabBarElements;
  final RxInt? groupValue;
  final Function(int?)? callBack;
  final RxList<bool>? tabBarValue;
  const TabsBar({
    Key? key,
    this.tabBarElements = const [],
    this.groupValue,
    this.callBack,
    this.tabBarValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          children: [
            const Spacer(
              flex: 2,
            ),
            Expanded(
              flex: 4,
              child: CupertinoSlidingSegmentedControl(
                groupValue: groupValue?.value ?? false,
                children: {
                  for (int i = 0; i < tabBarElements.length; i++)
                    i: tabBarValue![i]
                        ? TabBarTab(tabBarElements[i], 1)
                        : TabBarTab(tabBarElements[i], 0)
                },
                backgroundColor: CupertinoColors.tertiarySystemFill,
                thumbColor: tertiaryColor,
                onValueChanged: (newVal) {
                  // groupValue.value = newVal;
                  // ;
                  // callBack(newVal);

                  // for (int i = 0; i < tabBarValue.length; i++)
                  //   tabBarValue[i] = false;
                  // tabBarValue[newVal] = true;
                },
              ),
            ),
            const Spacer(
              flex: 2,
            ),
          ],
        ),
      );
    });
  }
}

class TabBarTab extends StatelessWidget {
  final String text;
  final int val;

  const TabBarTab(
    this.text,
    this.val, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text.tr,
        style: TextStyle(
            color: val == 1 ? Colors.white : Colors.black, fontSize: 11),
      ),
    );
  }
}
