import 'package:flutter/material.dart';

/// This widget is used as a container for all routed screens
/// It helps preserve state of all child screens and providers
class ShellRouteWidget extends StatelessWidget {
  const ShellRouteWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
