/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/back.svg
  String get back => 'assets/icons/back.svg';

  /// File path: assets/icons/bolt.svg
  String get bolt => 'assets/icons/bolt.svg';

  /// File path: assets/icons/bug.svg
  String get bug => 'assets/icons/bug.svg';

  /// File path: assets/icons/chevrons-right-high-contrast.svg
  String get chevronsRightHighContrast =>
      'assets/icons/chevrons-right-high-contrast.svg';

  /// File path: assets/icons/chevrons-right-low-contrast.svg
  String get chevronsRightLowContrast =>
      'assets/icons/chevrons-right-low-contrast.svg';

  /// File path: assets/icons/circle-plus.svg
  String get circlePlus => 'assets/icons/circle-plus.svg';

  /// File path: assets/icons/cloud-check.svg
  String get cloudCheck => 'assets/icons/cloud-check.svg';

  /// File path: assets/icons/copy.svg
  String get copy => 'assets/icons/copy.svg';

  /// File path: assets/icons/empty_log.svg
  String get emptyLog => 'assets/icons/empty_log.svg';

  /// File path: assets/icons/eraser.svg
  String get eraser => 'assets/icons/eraser.svg';

  /// File path: assets/icons/ic_launcher.png
  AssetGenImage get icLauncher =>
      const AssetGenImage('assets/icons/ic_launcher.png');

  /// File path: assets/icons/ic_launcher_splash.png
  AssetGenImage get icLauncherSplash =>
      const AssetGenImage('assets/icons/ic_launcher_splash.png');

  /// File path: assets/icons/refresh.svg
  String get refresh => 'assets/icons/refresh.svg';

  /// File path: assets/icons/settings.svg
  String get settings => 'assets/icons/settings.svg';

  /// File path: assets/icons/uk-flag.svg
  String get ukFlag => 'assets/icons/uk-flag.svg';

  /// File path: assets/icons/uk.png
  AssetGenImage get uk => const AssetGenImage('assets/icons/uk.png');

  /// File path: assets/icons/world-search.svg
  String get worldSearch => 'assets/icons/world-search.svg';

  /// List of all assets
  List<dynamic> get values => [
    back,
    bolt,
    bug,
    chevronsRightHighContrast,
    chevronsRightLowContrast,
    circlePlus,
    cloudCheck,
    copy,
    emptyLog,
    eraser,
    icLauncher,
    icLauncherSplash,
    refresh,
    settings,
    ukFlag,
    uk,
    worldSearch,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/bg.png
  AssetGenImage get bg => const AssetGenImage('assets/images/bg.png');

  /// File path: assets/images/logo.svg
  String get logo => 'assets/images/logo.svg';

  /// List of all assets
  List<dynamic> get values => [bg, logo];
}

class Assets {
  const Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
