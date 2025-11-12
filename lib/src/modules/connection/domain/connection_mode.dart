import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:segment/src/shared/errors/app_exceptions.dart';

enum ConnectionMode {
  proxy(1),
  vpn(2);

  final int value;

  const ConnectionMode(this.value);

  factory ConnectionMode.fromValue(int value) => switch (value) {
        1 => proxy,
        2 => vpn,
        _ => throw ConnectionModeException(value)
      };

  ConnectionMode get getToggle => switch (this) { proxy => vpn, vpn => proxy };
}

final connectionModeProvider =
// Just returning proxy mode as the default mode
    StateProvider<ConnectionMode>((ref) => ConnectionMode.vpn);
