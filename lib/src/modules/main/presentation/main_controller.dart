import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proxy_core/gen/bindings/ProxyCoreService.pb.dart';
import 'package:segment/src/modules/connection/application/connection_service.dart';
import 'package:segment/src/modules/connection_config/data/connection_config_repo.dart';
import 'package:segment/src/modules/core/data/core_repo.dart';
import 'package:segment/src/shared/errors/app_exceptions.dart';

final mainControllerProvider =
    AsyncNotifierProvider<MainController, MainState>(MainController.new);

class MainController extends AsyncNotifier<MainState> {
  @override
  Future<MainState> build() async {
    // Await the preparation to complete
    ref.watch(connectionServiceProvider).prepare();

    // Disconnect on changing mode: proxy <=> vpn
    ref.onDispose(ref.read(connectionServiceProvider).disconnect);

    // Check if core is running directly after initialization (after app closed and reopened)
    final isCoreRunning = await ref.read(isCoreRunningProvider.future);
    return isCoreRunning ? MainState.connected : MainState.ready;
  }

  Future<AsyncValue<void>> connect() async {
    if (ref.read(connectionConfigRepoProvider).config == null) {
      state = AsyncValue.error(NoConfigException(), StackTrace.current);
      return state;
    }

    state = AsyncValue.data(MainState.loading);

    final result =
        await AsyncValue.guard(ref.read(connectionServiceProvider).connect);
    if (result is AsyncError) {
      disconnect();
    }
    return result;
  }

  Future<AsyncValue<List<PingResult>>> testAfterConnected() async {
    final result = await AsyncValue.guard(
        ref.read(connectionServiceProvider).testConnection);
    if (result is AsyncData) {
      _setConnected();
    } else {
      // If test returns/throws error [AsyncError] back to ready to try again
      disconnect();
    }

    return result;
  }

  void disconnect() async {
    state = AsyncValue.data(MainState.loading);
    await ref.read(connectionServiceProvider).disconnect();
    _setReady();
  }

  _setReady() => state = AsyncValue.data(MainState.ready);

  _setConnected() => state = AsyncValue.data(MainState.connected);
}

enum MainState { ready, loading, connected }
