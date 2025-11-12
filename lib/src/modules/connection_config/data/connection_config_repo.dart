import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:segment/src/modules/connection_config/domain/connection_config_model.dart';

final Provider<ConnectionConfigRepo> connectionConfigRepoProvider =
    Provider<ConnectionConfigRepo>((_) => ConnectionConfigRepo());

class ConnectionConfigRepo {
  ConnectionConfigModel? config;
}
