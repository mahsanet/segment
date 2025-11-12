import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:segment/src/shared/presentation/snack_bar/app_snack_bar.dart';

/// Shows a custom styled SnackBar with black background and white text
void showCustomSnackBar(BuildContext context, String message, Icon icon) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    AppSnackBar.connectionStatus(
      duration: const Duration(seconds: 3),
      message: message,
      margin: EdgeInsets.only(
        bottom: 150.h,
        left: 20.w,
        right: 20.w,
      ),
    ),
  );
}
