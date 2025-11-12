import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:segment/src/shared/data/shared_prefs_repo.dart';

final connectionTimerProvider = StateNotifierProvider<
    MainConnectButtonTimerController, MainConnectButtonTimerState>((ref) {
  return MainConnectButtonTimerController(ref.watch(sharedPrefsRepoProvider));
});

class MainConnectButtonTimerController
    extends StateNotifier<MainConnectButtonTimerState> {
  Timer? _timer;
  final SharedPrefsRepo _sharedPrefsRepo;

  MainConnectButtonTimerController(this._sharedPrefsRepo)
      : super(MainConnectButtonTimerState()) {
    _initializeFromStoredTime();
  }

  Future<void> _initializeFromStoredTime() async {
    final storedTime = await _sharedPrefsRepo.getConnectionStartTime();
    if (storedTime != null) {
      state = state.copyWith(
        startTime: storedTime,
        activeTime: DateTime.now().difference(storedTime),
        isConnected: true,
      );
      _startTimer();
    }
  }

  void _startConnection() {
    final now = DateTime.now();
    _timer?.cancel();

    state = state.copyWith(
      startTime: now,
      activeTime: Duration.zero,
      isConnected: true,
    );

    _sharedPrefsRepo.saveConnectionStartTime(now);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.startTime != null) {
        state = state.copyWith(
          activeTime: DateTime.now().difference(state.startTime!),
        );
      }
    });
  }

  void _stopConnection() {
    _timer?.cancel();
    _timer = null;

    state = MainConnectButtonTimerState();
    _sharedPrefsRepo.clearConnectionStartTime();
  }

  void updateConnectionStatus({required bool isConnected}) {
    if (isConnected && !state.isConnected) {
      _startConnection();
    } else if (!isConnected && state.isConnected) {
      _stopConnection();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class MainConnectButtonTimerState {
  final DateTime? startTime;
  final Duration activeTime;
  final bool isConnected;

  MainConnectButtonTimerState({
    this.startTime,
    this.activeTime = Duration.zero,
    this.isConnected = false,
  });

  MainConnectButtonTimerState copyWith({
    DateTime? startTime,
    Duration? activeTime,
    bool? isConnected,
  }) {
    return MainConnectButtonTimerState(
      startTime: startTime ?? this.startTime,
      activeTime: activeTime ?? this.activeTime,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}
