import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:segment/src/modules/connection/domain/connection_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefsRepoProvider =
    Provider.autoDispose((ref) => SharedPrefsRepo());

// TODO: Use SharedPreferencesException here
class SharedPrefsRepo {
  static const _firstRun = 'first_run';
  static const _selectedConnectionMode = 'selected_connection_mode';
  static const _connectionStartTime = 'connection_start_time';
  static const _connectionConfig = 'connection_config';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<bool> isFirstRun() async => (await _prefs).getBool(_firstRun) ?? true;

  Future<bool> setFirstRunToFalse() async =>
      (await _prefs).setBool(_firstRun, false);

  Future<ConnectionMode> selectedConnectionMode() async {
    // 1 = proxy, 2 = vpn
    // See [ConnectionMode.fromValue()]
    final value = (await _prefs).getInt(_selectedConnectionMode) ?? 2;
    return ConnectionMode.fromValue(value);
  }

  Future<void> saveConnectionStartTime(DateTime timestamp) async {
    await (await _prefs)
        .setString(_connectionStartTime, timestamp.toIso8601String());
  }

  Future<void> saveConnectionConfig(String config) async {
    await (await _prefs).setString(_connectionConfig, config);
  }

  Future<String?> getConnectionConfig() async {
    return (await _prefs).getString(_connectionConfig);
  }

  Future<void> clearConnectionConfig() async {
    await (await _prefs).remove(_connectionConfig);
  }

  Future<DateTime?> getConnectionStartTime() async {
    final timestamp = (await _prefs).getString(_connectionStartTime);
    return timestamp != null ? DateTime.parse(timestamp) : null;
  }

  Future<void> clearConnectionStartTime() async {
    await (await _prefs).remove(_connectionStartTime);
  }
}
