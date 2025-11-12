import 'package:segment/src/modules/connection/application/connection_service.dart';
import 'package:segment/src/modules/connection/domain/connection_mode.dart';

class ProxyConnectionService extends IConnectionService {
  ProxyConnectionService(super._ref);

  @override
  void prepare() => coreRepo.initialize();

  @override
  Future<void> connect() => coreRepo.start(
      ConnectionMode.proxy, connectionConfigRepo.config!, coreType);

  @override
  Future<void> disconnect() => coreRepo.stop();
}
