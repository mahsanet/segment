import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:segment/src/shared/constants/app_theme.dart';

class WindowsSpecificWrapper extends StatelessWidget {
  final Widget child;

  const WindowsSpecificWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return WindowBorder(
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          ColoredBox(
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                Expanded(child: WindowTitleBarBox(child: MoveWindow())),
                MinimizeWindowButton(
                    colors: AppTheme.windowsWrapperButtonColors),
                MaximizeWindowButton(
                    colors: AppTheme.windowsWrapperButtonColors),
                CloseWindowButton(
                    colors: AppTheme.windowsWrapperCloseButtonColors),
              ],
            ),
          ),
          Expanded(child: child)
        ],
      ),
    );
  }
}
