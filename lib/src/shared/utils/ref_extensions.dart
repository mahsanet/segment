import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:segment/src/shared/utils/async_value_extensions.dart';

extension UIProviderError<T> on WidgetRef {
  /// only pass [onRetry] if something other than invalidating provider
  /// needs to be called
  void showToastOnErrorWithRetry(
    BuildContext context,
    ProviderBase<AsyncValue<T>>? provider, {
    VoidCallback? onRetry,
    Duration? duration,
  }) {
    if (provider == null) return;
    listen(provider, (_, state) {
      state.showSnackBarOnError(
        context,
        onRetry: onRetry ?? () => invalidate(provider),
        duration: duration,
      );
    });
  }

  void showToastOnError(
    BuildContext context,
    ProviderBase<AsyncValue<T>> provider,
  ) {
    listen(provider, (_, state) {
      state.showSnackBarOnError(context);
    });
  }
}
