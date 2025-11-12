import 'package:segment/src/modules/connection/application/connection_service.dart';
import 'package:segment/src/modules/connection/domain/connection_mode.dart';

class VPNConnectionService extends IConnectionService {
  VPNConnectionService(super._ref);

  @override
  void prepare() => coreRepo.initialize();

  @override
  Future<void> connect() async {
    //await _firstTestConfigInProxyMode();
    return coreRepo.start(
        ConnectionMode.vpn, connectionConfigRepo.config!, coreType);
  }

  // This is just to see if the the config is working and then connect in vpn mode
  // Future<void> _firstTestConfigInProxyMode() async {
  //   await coreRepo.start(ConnectionMode.proxy, connectionConfigRepo.config);
  //   await testConnection();
  // }

  @override
  Future<void> disconnect() => coreRepo.stop();
}
