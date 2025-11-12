import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:segment/src/modules/connection_config/data/connection_config_repo.dart';
import 'package:segment/src/modules/connection_config/domain/connection_config_model.dart';
import 'package:segment/src/modules/connection_config/presentation/widgets/connection_config_input_state.dart';
import 'package:segment/src/modules/core/data/core_repo.dart';
import 'package:segment/src/shared/data/shared_prefs_repo.dart';

final connectionConfigControllerProvider = NotifierProvider<
    ConnectionConfigInputController,
    ConnectionConfigInputState>(ConnectionConfigInputController.new);

class ConnectionConfigInputController
    extends Notifier<ConnectionConfigInputState> {
  late SharedPrefsRepo _sharedPrefsRepo;

  @override
  ConnectionConfigInputState build() {
    final currentConfig =
        ref.watch(connectionConfigRepoProvider).config?.asStringValue;
    _sharedPrefsRepo = ref.read(sharedPrefsRepoProvider);
    final coreStatus = ref.watch(isCoreRunningProvider).value ?? false;
    _loadSavedConfig();
    return ConnectionConfigInputState(
        input: currentConfig ?? '', isDisabled: coreStatus);
  }

  Future<void> _loadSavedConfig() async {
    final savedConfigJson = await _sharedPrefsRepo.getConnectionConfig();
    if (savedConfigJson != null && savedConfigJson.isNotEmpty) {
      updateInput(savedConfigJson);
    }
  }

  void updateInput(String input) {
    if (state.isDisabled || input.trim().isEmpty) return;
    try {
      final builtConfig = _buildConfig(input);
      ref.read(connectionConfigRepoProvider).config = builtConfig;
      _sharedPrefsRepo.saveConnectionConfig(builtConfig.asStringValue);
      state = state.copyWith(input: builtConfig.asStringValue, error: null);
    } catch (e) {
      state = state.copyWith(input: input, error: e.toString());
    }
  }

  ConnectionConfigModel _buildConfig(String input) {
    final trimmedInput = input.trim();
    late final ConnectionConfigModel config;

    // checking the first character of the input to determine if it's a link or a json
    if (!input.startsWith('{')) {
      config = ConnectionConfigModel.fromLink(configLink: trimmedInput);
    } else {
      // TODO: consider coreType here
      config = ConnectionConfigModel.fromJson(jsonDecode(trimmedInput));
    }

    return config;
  }

  void pasteInput(String input) {
    if (state.isDisabled) return;
    updateInput(input);
  }

  void clearInput() {
    if (state.isDisabled) return;
    state = state.copyWith(input: '', error: null);
    ref.read(connectionConfigRepoProvider).config = null;
    _sharedPrefsRepo.clearConnectionConfig();
  }
}
