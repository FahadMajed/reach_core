import 'package:flutter/material.dart';
import 'package:reach_core/core/core.dart';

class Loading extends StatelessWidget {
  final Color color;
  final double? value;

  const Loading({
    Key? key,
    this.color = darkBlue300,
    this.value,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: padding16,
        decoration: const BoxDecoration(
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

class LoadingScaffold extends StatelessWidget {
  const LoadingScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReachScaffold(
      title: "...",
      withWhiteContainer: true,
      body: const [Loading()],
    );
  }
}

class ErrorScaffold extends StatelessWidget {
  const ErrorScaffold(
    this.e, {
    Key? key,
  }) : super(key: key);
  final Object e;
  @override
  Widget build(BuildContext context) {
    return ReachScaffold(
      withWhiteContainer: true,
      body: [ErrorWidget(e)],
    );
  }
}
