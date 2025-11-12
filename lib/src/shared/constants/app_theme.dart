// app_theme.dart
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:segment/src/shared/constants/app_colors.dart';

final class AppTheme {
  AppTheme._();

  // TODO: Refactor if Dark Theme added
  static final appTheme = ThemeData.light(
    useMaterial3: true,
  ).copyWith(
      scaffoldBackgroundColor: AppColors.transparent,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
      ));

  static const lightSystemOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: AppColors.transparent,
      systemNavigationBarColor: AppColors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark);

  static final windowsWrapperButtonColors = WindowButtonColors(
      iconNormal: AppColors.white,
      mouseOver: AppColors.white.withValues(alpha: 0.1),
      mouseDown: AppColors.white.withValues(alpha: 0.54),
      iconMouseOver: AppColors.white.withValues(alpha: 0.5),
      iconMouseDown: AppColors.white.withValues(alpha: 0.5));

  static final windowsWrapperCloseButtonColors = WindowButtonColors(
      mouseOver: AppColors.windowCloseHover,
      mouseDown: AppColors.windowClosePress,
      iconNormal: AppColors.white,
      iconMouseOver: AppColors.white);
}
