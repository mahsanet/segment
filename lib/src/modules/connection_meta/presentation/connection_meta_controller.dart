import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:segment/src/modules/connection_meta/data/connection_meta_repo.dart';
import 'package:segment/src/modules/connection_meta/domain/connection_meta_model.dart';

final connectionMetaControllerProvider =
    StateNotifierProvider<ConnectionMetaController, ConnectionMetaModel?>(
        (ref) {
  final metaController = ConnectionMetaController(ref);
  metaController.fetchConnectionMeta();
  return metaController;
});

class ConnectionMetaController extends StateNotifier<ConnectionMetaModel?> {
  final Ref _ref;

  ConnectionMetaController(this._ref) : super(null);

  void fetchConnectionMeta() async {
    final result = await AsyncValue.guard(
        _ref.read(connectionMetaRepoProvider).fetchConnectionMeta);

    state = result.when(
      data: (data) => data,
      loading: () => null,
      // Return null on error cause we don't need this controller
      // only when MainController is connected
      error: (error, stack) => null,
    );
  }

  void clear() {
    state = null;
  }
}
