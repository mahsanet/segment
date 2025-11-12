import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:segment/src/shared/constants/app_colors.dart';
import 'package:segment/src/shared/constants/app_sizes.dart';
import 'package:segment/src/shared/constants/app_text_styles.dart';

// TODO: Check TextStyles, Colors and Icons
class AppSnackBar extends SnackBar {
  const AppSnackBar._({
    required super.content,
    super.duration,
    super.key,
    // ignore: unused_element_parameter
    super.behavior = SnackBarBehavior.floating,
    super.shape,
    super.backgroundColor,
    super.margin,
  });

  factory AppSnackBar.connectionStatus({
    required String message,
    Duration? duration,
    Key? key,
    VoidCallback? onRetry,
    EdgeInsetsGeometry? margin,
  }) =>
      AppSnackBar._(
        key: key,
        duration: duration ?? const Duration(seconds: 5),
        backgroundColor: AppColors.black,
        shape: _shape(),
        content: _SnackBarContent(
          icon: Icons.info_rounded,
          iconColor: AppColors.white,
          msg: message,
          onRetry: onRetry,
        ),
        margin: margin,
      );

  factory AppSnackBar.error({
    required String message,
    Duration? duration,
    Key? key,
    VoidCallback? onRetry,
  }) =>
      AppSnackBar._(
        key: key,
        duration: duration ?? const Duration(seconds: 5),
        backgroundColor: AppColors.red,
        shape: _shape(),
        content: _SnackBarContent(
          icon: Icons.error_rounded,
          iconColor: AppColors.white,
          msg: message,
          onRetry: onRetry,
        ),
      );

  factory AppSnackBar.positive({
    required String message,
    Key? key,
  }) =>
      AppSnackBar._(
        key: key,
        backgroundColor: AppColors.green,
        shape: _shape(),
        content: _SnackBarContent(
          icon: Icons.check_circle_rounded,
          iconColor: AppColors.white,
          msg: message,
        ),
      );

  factory AppSnackBar.info({
    required String message,
    Key? key,
  }) =>
      AppSnackBar._(
        key: key,
        backgroundColor: AppColors.white,
        shape: _shape(),
        content: _SnackBarContent(
          icon: Icons.info_rounded,
          iconColor: AppColors.white,
          textStyle: AppTextStyles.h1,
          msg: message,
        ),
      );

  factory AppSnackBar.custom({
    required String message,
    Key? key,
    Color? backgroundColor = AppColors.black,
    IconData icon = Icons.info_outline,
    Color? textColor = AppColors.white,
    EdgeInsetsGeometry? margin,
  }) =>
      AppSnackBar._(
        key: key,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        content: _SnackBarContent(
          icon: icon,
          iconColor: AppColors.white,
          msg: message,
          textStyle: AppTextStyles.snackBarMessage.copyWith(
            color: textColor,
          ),
        ),
        margin: margin,
      );

  static ShapeBorder _shape() => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.p8),
      );
}

class _SnackBarContent extends StatelessWidget {
  const _SnackBarContent({
    required this.icon,
    required this.iconColor,
    required this.msg,
    this.onRetry,
    this.textStyle,
  });

  final String msg;
  final IconData icon;
  final VoidCallback? onRetry;
  final TextStyle? textStyle;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        SizedBox(width: AppSizes.p16),
        Expanded(
          child: Text(
            msg,
            style: AppTextStyles.snackBarMessage,
            maxLines: 7,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
