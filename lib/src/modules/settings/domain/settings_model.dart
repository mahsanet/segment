import 'package:proxy_core/constants/core_names.dart';
import 'package:segment/src/modules/connection/domain/connection_mode.dart';

enum ConnectionLoadType {
  normal,
  loadBalance;
}

class SettingsModel {
  final CoreNames coreType;
  final ConnectionLoadType connectionLoadType;
  final ConnectionMode connectionMode;

  const SettingsModel(
      {required this.connectionMode,
      required this.coreType,
      required this.connectionLoadType});

  SettingsModel copyWith({
    CoreNames? coreType,
    ConnectionLoadType? connectionLoadType,
    ConnectionMode? connectionMode,
  }) {
    return SettingsModel(
      coreType: coreType ?? this.coreType,
      connectionLoadType: connectionLoadType ?? this.connectionLoadType,
      connectionMode: connectionMode ?? this.connectionMode,
    );
  }
}
