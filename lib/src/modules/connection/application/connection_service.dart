import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proxy_core/constants/core_names.dart';
import 'package:proxy_core/gen/bindings/ProxyCoreService.pb.dart';
import 'package:segment/src/modules/connection/application/proxy_connection_service.dart';
import 'package:segment/src/modules/connection/application/vpn_connection_service.dart';
import 'package:segment/src/modules/connection/domain/connection_mode.dart';
import 'package:segment/src/modules/connection_config/data/connection_config_repo.dart';
import 'package:segment/src/modules/core/data/core_repo.dart';
import 'package:segment/src/modules/settings/data/settings_repo.dart';

final connectionServiceProvider = Provider<IConnectionService>((ref) {
  final connectionMode = ref.watch(connectionModeProvider);
  return switch (connectionMode) {
    ConnectionMode.proxy => ProxyConnectionService(ref),
    ConnectionMode.vpn => VPNConnectionService(ref)
  };
});

abstract class IConnectionService {
  final Ref _ref;

  IConnectionService(this._ref);

  CoreRepo get coreRepo => _ref.read(coreRepoProvider);

  CoreNames get coreType => _ref.read(settingsRepoProvider).settings.coreType;

  ConnectionConfigRepo get connectionConfigRepo =>
      _ref.read(connectionConfigRepoProvider);

  void prepare();

  Future<List<PingResult>> testConnection() =>
      _ref.read(coreRepoProvider).measurePing(null);

  Future<void> connect();

  Future<void> disconnect();
}
