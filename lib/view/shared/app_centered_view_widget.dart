import 'package:flutter/material.dart';

class AppCenteredViewWidget extends StatelessWidget {
  final Widget child;
  const AppCenteredViewWidget({Key key,  this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: child,
      ),
    );
  }
}
