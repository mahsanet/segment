import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:segment/src/shared/constants/app_colors.dart';

final class AppTextStyles {
  AppTextStyles._();

  static const _letterSpacing = -0.02;
  static const fontFamily = 'Lato';

  ///--------------------------- Headings ---------------------------
  static final h1 = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 30.sp,
  );

  ///--------------------------- Main Screen ---------------------------
  static final mainScreenHint = TextStyle(
    fontSize: 18.sp,
    fontFamily: fontFamily,
    color: AppColors.black,
    fontWeight: FontWeight.w300,
  );

  static final configText = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.black54,
  );

  static final ipAddressText = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.black54,
  );

  static final pingText = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.pingGreen,
  );

  ///--------------------------- Utility ---------------------------
  static final snackBarMessage = TextStyle(
    color: AppColors.white,
    fontWeight: FontWeight.normal,
    fontSize: 12.sp,
    letterSpacing: _letterSpacing,
  );

  ///--------------------------- Connection Config Modal Text Styles ---------------------------
  static final modalHeader = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static final modalDescription = TextStyle(
    fontSize: 14.sp,
    color: AppColors.black87,
  );

  static final modalButtonText = TextStyle(
    color: AppColors.grey,
    fontSize: 14.sp,
  );

  static final modalSubmitButtonText = TextStyle(
    color: AppColors.white,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
  );

  ///--------------------------- Connection Config Input Text Styles ---------------------------
  static final inputHintText = TextStyle(
    color: AppColors.grey,
    fontSize: 14.sp,
  );

  static final inputText = TextStyle(
    fontSize: 14.sp,
    color: AppColors.black87,
  );

  ///--------------------------- MainConnectButton Text Styles ---------------------------
  static final activeTimeLabel = TextStyle(
    fontSize: 12.sp,
    color: AppColors.activeTimeLabel,
    fontWeight: FontWeight.w500,
  );

  static final activeTimeValue = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.activeTimeValue,
  );

  ///--------------------------- Settings Modal Text Styles ---------------------------
  static final settingsModalTitle = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static final settingsModalSectionTitle = TextStyle(
    fontSize: 14.sp,
    color: AppColors.black54,
  );

  static final settingsModalRestoreButton = TextStyle(
    color: AppColors.black54,
    fontSize: 14.sp,
  );

  static final settingsModalConfirmButton = TextStyle(
    color: AppColors.white,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
  );

  ///--------------------------- Radio Option Text Styles ---------------------------
  static final radioOptionTitle = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.black87,
  );

  static final radioOptionSubtitle = TextStyle(
    fontSize: 14.sp,
    color: AppColors.black54,
    fontStyle: FontStyle.normal,
  );
}