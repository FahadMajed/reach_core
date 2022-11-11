import 'package:flutter/material.dart';
import 'package:reach_core/core/ui/widgets/shared/reach_scaffold.dart';

class ErrorScaffold extends StatelessWidget {
  final dynamic e;

  const ErrorScaffold(this.e, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReachScaffold(body: [Text(e.toString())]);
  }
}
