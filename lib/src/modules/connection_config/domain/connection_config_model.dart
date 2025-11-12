import 'dart:convert';

import 'package:proxy_core/constants/core_names.dart';
import 'package:proxy_url_parser/proxy_url_parser.dart';

class ConnectionConfigModel {
  ConnectionConfigModel._({
    required this.configLink,
    required this.rawJsonConfig,
  }) : assert(
          rawJsonConfig != null || configLink != null,
          'At least one of rawJsonConfig or configLink must be provided',
        ) {
    if (configLink != null) {
      _parsedConfig = ProxyUrlParser.parse(configLink!);
    }
  }

  /// For raw user-entered json
  final Map<String, dynamic>? rawJsonConfig;

  /// For user-entered config link
  final String? configLink;

  /// For parsed config from [configLink]
  late final ProtocolConfigBase? _parsedConfig;

  String get configName {
    if (_parsedConfig != null) return _parsedConfig.remark;
    try {
      return rawJsonConfig!['remark'] ??
          rawJsonConfig!['outbounds']?[0]?['remark'] ??
          'Config';
    } catch (e) {
      return 'Config';
    }
  }

  /// Returns full config for the given core to start the core.
  String getFullJsonConfig(CoreNames core) {
    final Map<String, dynamic> config;
    if (_parsedConfig != null) {
      switch (core) {
        case CoreNames.xray:
           config = ProxyUrlParser.injectToConfig(
              _baseConfig, _parsedConfig.toXrayJson(allowInsecure: true))
            ..['outbounds'][0]['tag'] = 'proxy';
        case CoreNames.outline:
          config = _parsedConfig.toOutlineJson();
      }
    } else {
      config =  rawJsonConfig!;
    }

    return jsonEncode(config);
  }

  factory ConnectionConfigModel.fromJson(Map<String, dynamic> json) {
    return ConnectionConfigModel._(
      configLink: null,
      rawJsonConfig: json,
    );
  }

  factory ConnectionConfigModel.fromLink({
    required String configLink,
  }) =>
      ConnectionConfigModel._(
        configLink: configLink,
        rawJsonConfig: null,
      );

  /// Returns link if [configLink] is not null and raw config otherwise
  String get asStringValue => configLink ?? _parsedConfig.toString();

  static const _baseConfig = {
    "log": {"level": "debug"},
    "inbounds": [
      {
        "listen": "127.0.0.1",
        "port": 2080,
        "protocol": "socks",
        "settings": {"auth": "noauth", "udp": true},
        "sniffing": {
          "destOverride": ["http", "tls", "quic", "fakedns"],
          "enabled": false,
          "routeOnly": true
        },
        "tag": "socks"
      }
    ],
    "dns": {
      "servers": ["1.1.1.1", "8.8.8.8"]
    },
    "routing": {
      "rules": [
        {
          "type": "field",
          "inboundTag": ["socks"],
          "outboundTag": "proxy"
        }
      ]
    },
  };
}
