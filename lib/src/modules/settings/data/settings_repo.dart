import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proxy_core/constants/core_names.dart';
import 'package:segment/src/modules/connection/domain/connection_mode.dart';
import 'package:segment/src/modules/settings/domain/settings_model.dart';

class SettingRepo {
  final SettingsModel defaultSettings = SettingsModel(
    coreType: CoreNames.xray,
    connectionLoadType: ConnectionLoadType.normal,
    connectionMode: ConnectionMode.vpn,
  );

  SettingsModel? _userSettings;

  SettingsModel get settings => _userSettings ?? defaultSettings;

  set settings(SettingsModel? settings) => _userSettings = settings;
}

final settingsRepoProvider = AutoDisposeProvider((ref) {
  return SettingRepo();
});
