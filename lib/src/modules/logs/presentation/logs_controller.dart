import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:segment/src/modules/core/data/core_repo.dart';

final logsControllerProvider = AsyncNotifierProvider<LogsController, String>(
  () => LogsController(),
);

class LogsController extends AsyncNotifier<String> {
  final _refreshInterval = Duration(seconds: 1);

  Timer? _refreshTimer;
  String _allLogs = '';

  @override
  Future<String> build() async {
    // Cancel existing timer when rebuilding
    ref.onDispose(_stopAutoRefresh);

    final isCoreRunning = await ref.watch(isCoreRunningProvider.future);
    if (isCoreRunning) {
      // Listen to changes in dependencies
      _startAutoRefresh();
    } else {
      _resetLogs();
    }

    return _allLogs;
  }


  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(_refreshInterval, (_) {
      _safeFetchLogs();
    });
  }

  void _stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  void _safeFetchLogs() {
    // Use a "fire and forget" approach that doesn't block the timer callback
    Future(() async {
      try {
        await fetchLogs();
      } catch (e) {
        // Silently handle errors that might occur due to provider rebuilds
      }
    });
  }

  Future<void> fetchLogs() async {
    // Get a reference to the repo outside the async operation
    final repo = ref.read(coreRepoProvider);
    final logResponse = await repo.fetchLogs();

    if (logResponse.logs.isNotEmpty) {
      _allLogs += "\n${logResponse.logs}";
      state = AsyncData(_allLogs);
    }
  }

  Future<void> clearLogs() async {
    await ref.read(coreRepoProvider).clearLogs();
    _resetLogs();
  }

  void _resetLogs() {
    _allLogs = '';
    state = AsyncData(_allLogs);
  }
}
