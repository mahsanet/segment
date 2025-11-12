import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:segment/gen/assets.gen.dart';
import 'package:segment/src/shared/constants/app_colors.dart';

final class AppIcons {
  AppIcons._();

  // SVG Asset Paths
  static const String logoPath = 'assets/images/logo.svg';
  static const String bugPath = 'assets/icons/bug.svg';
  static const String settingsPath = 'assets/icons/settings.svg';
  static const String circlePlusPath = 'assets/icons/circle-plus.svg';
  static const String cloudCheckPath = 'assets/icons/cloud-check.svg';
  static const String refreshPath = 'assets/icons/refresh.svg';
  static const String boltPath = 'assets/icons/bolt.svg';
  static const String backPath = 'assets/icons/back.svg';
  static const String copyPath = 'assets/icons/copy.svg';
  static const String chevronsRightLowContrastPath =
      'assets/icons/chevrons-right-low-contrast.svg';
  static const String chevronsLeftHighContrastPath =
      'assets/icons/chevrons-left-high-contrast.svg';
  static const String chevronsLeftLowContrastPath =
      'assets/icons/chevrons-left-low-contrast.svg';

  // Image Asset Paths
  static const String ukFlagPath = 'assets/icons/uk.png';

  // SVG Widgets with default sizes and colors
  static SvgPicture logo({double height = 35}) {
    SvgPicture.asset(
      logoPath,
      height: height,
    );
    return SvgPicture.asset(
      Assets.images.logo,
      height: height,
    );
  }

  static SvgPicture bug({double width = 30, double height = 30}) {
    return SvgPicture.asset(
      Assets.icons.bug,
      colorFilter: ColorFilter.mode(AppColors.yellow, BlendMode.srcIn),
      width: width,
      height: height,
    );
  }

  static SvgPicture back({double width = 30, double height = 30}) {
    return SvgPicture.asset(
      Assets.icons.back,
      colorFilter: ColorFilter.mode(AppColors.accent, BlendMode.srcIn),
      width: width,
      height: height,
    );
  }

  static SvgPicture copy({double width = 30, double height = 30}) {
    return SvgPicture.asset(
      Assets.icons.copy,
      colorFilter: ColorFilter.mode(AppColors.accent, BlendMode.srcIn),
      width: width,
      height: height,
    );
  }

  static SvgPicture settings({double width = 30, double height = 30}) {
    return SvgPicture.asset(
      Assets.icons.settings,
      colorFilter: ColorFilter.mode(AppColors.accent, BlendMode.srcIn),
      width: width,
      height: height,
    );
  }

  static SvgPicture circlePlus({double width = 30, double height = 30}) {
    return SvgPicture.asset(
      Assets.icons.circlePlus,
      colorFilter: ColorFilter.mode(AppColors.accent, BlendMode.srcIn),
      width: width,
      height: height,
    );
  }

  static SvgPicture cloudCheck({double width = 100, double height = 100}) {
    return SvgPicture.asset(
      Assets.icons.cloudCheck,
      width: width,
      height: height,
    );
  }

  static SvgPicture emptyLog({double width = 100, double height = 100}) {
    return SvgPicture.asset(
      Assets.icons.emptyLog,
      width: width,
      height: height,
    );
  }

  static SvgPicture eraser({double width = 25, double height = 25}) {
    return SvgPicture.asset(
      Assets.icons.eraser,
      width: width,
      height: height,
    );
  }

  static SvgPicture refresh(
      {double width = 16, double height = 16, Color color = AppColors.grey}) {
    return SvgPicture.asset(
      Assets.icons.refresh,
      width: width,
      height: height,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  static SvgPicture bolt(
      {double width = 31,
      double height = 31,
      Color color = AppColors.boltDefault}) {
    return SvgPicture.asset(
      Assets.icons.bolt,
      width: width,
      height: height,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  static SvgPicture chevronsRightLowContrast(
      {double width = 24, double height = 24}) {
    return SvgPicture.asset(
      Assets.icons.chevronsRightLowContrast,
      width: width,
      height: height,
    );
  }

  static SvgPicture chevronsLeftHighContrast(
      {double width = 24, double height = 24}) {
    return SvgPicture.asset(
      Assets.icons.chevronsRightHighContrast,
      width: width,
      height: height,
    );
  }

  // Material Icons
  static const Icon chevronRight = Icon(
    Icons.chevron_right,
    color: AppColors.grey,
  );

  static const Icon arrowBackIos = Icon(
    Icons.arrow_back_ios,
    color: AppColors.grey,
    size: 14,
  );

  static const Icon check = Icon(Icons.check, color: AppColors.white);

  // static Icon vpnModeIcon = const Icon(Icons.vpn_key_rounded);
  // static Icon proxyModeIcon = const Icon(Icons.input_rounded);

  static Icon deleteOutline({
    Color color = AppColors.grey,
    double size = 20,
  }) {
    return Icon(
      Icons.delete_outline,
      color: color,
      size: size,
    );
  }

  // Loading indicators
  static Widget loadingIndicator(
      {double size = 33,
      double strokeWidth = 4,
      Color color = AppColors.yellow}) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
