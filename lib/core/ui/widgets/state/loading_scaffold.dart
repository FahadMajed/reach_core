import 'package:flutter/cupertino.dart';
import 'package:reach_core/core/core.dart';

class LoadingScaffold extends StatelessWidget {
  const LoadingScaffold({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReachScaffold(
      body: const [Loading()],
      withWhiteContainer: false,
    );
  }
}
