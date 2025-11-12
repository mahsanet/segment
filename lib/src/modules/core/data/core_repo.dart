import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:proxy_core/constants/core_names.dart';
import 'package:proxy_core/gen/bindings/ProxyCoreService.pb.dart';
import 'package:proxy_core/models/proxy_core_config.dart';
import 'package:proxy_core/proxy_core.dart';
import 'package:segment/src/modules/connection/domain/connection_mode.dart';
import 'package:segment/src/modules/connection_config/domain/connection_config_model.dart';
import 'package:segment/src/shared/errors/app_exceptions.dart';

final coreRepoProvider = Provider<CoreRepo>((ref) => CoreRepo());

final isCoreRunningProvider = StreamProvider<bool>((ref) {
  final repository = ref.watch(coreRepoProvider);
  ref.onDispose(repository.dispose);
  return repository.coreStatusStream;
});

class CoreRepo {
  static const _defaultPingUrls = [
    "https://www.google.com/generate_204",
    "https://www.gstatic.com/generate_204"
  ];

  final _coreStatusController = StreamController<bool>.broadcast();
  bool _isDisposed = false;
  // Stream of core running status updates
  Stream<bool> get coreStatusStream => _coreStatusController.stream;

  void initialize() {
    ProxyCore.ins.initialize(onCoreStateChanged: _updateCoreStatus);
  }

  Future<void> start(
      ConnectionMode mode, ConnectionConfigModel config, CoreNames core) async {
    try {
      final coreConfig = await _buildCoreConfig(mode, config, core);
      await ProxyCore.ins.start(coreConfig);
    } catch (e) {
      await stop();
      throw CoreException(error: e);
    }
  }

  Future<void> stop() async {
    try {
      await ProxyCore.ins.stop();
    } catch (e) {
      throw CoreException(error: e);
    }
  }

  Future<List<PingResult>> measurePing([List<String>? customUrls]) async {
    try {
      final urls = customUrls ?? _defaultPingUrls;
      return await ProxyCore.ins.measurePing(urls);
    } catch (e) {
      throw CoreException(error: e);
    }
  }

  Future<ProxyCoreConfig> _buildCoreConfig(
      ConnectionMode mode, ConnectionConfigModel config, CoreNames core) async {
    final appDir = await _getAppDirectory();
    final coreConfig = config.getFullJsonConfig(core);

    return mode == ConnectionMode.vpn
        ? ProxyCoreConfig.inVpnMode(dir: appDir, config: coreConfig, core: core)
        : ProxyCoreConfig.inProxyMode(
            dir: appDir, config: coreConfig, core: core);
  }

  Future<void> _updateCoreStatus(bool isRunning) async {
    if (!_isDisposed) {
      _coreStatusController.add(isRunning);
    }
  }

  Future<String> _getAppDirectory() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<void> dispose() async {
    _isDisposed = true;
    await _coreStatusController.close();
  }

  Future<bool> isCoreRunning() async {
    try {
      return await ProxyCore.ins.isRunning;
    } catch (e) {
      throw CoreException(error: e);
    }
  }

  Future<LogResponse> fetchLogs() async {
    try {
      final logResponse = await ProxyCore.ins.fetchLogs();
      return logResponse;
    } catch (e) {
      throw CoreException(error: e);
    }
  }

  Future<void> clearLogs() async {
    try {
      await ProxyCore.ins.clearLogs();
    } catch (e) {
      throw CoreException(error: e);
    }
  }
}
