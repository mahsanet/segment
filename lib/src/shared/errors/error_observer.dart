import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:segment/src/shared/errors/error_logger.dart';

class ErrorObserver extends ProviderObserver {
  ErrorObserver();

  /// For catching and logging errors we use [didUpdateProvider] for now
  /// https://github.com/rrousselGit/riverpod/issues/1580#issuecomment-1584550146
  @override
  void didUpdateProvider(
      ProviderBase<Object?> provider,
      Object? previousValue,
      Object? newValue,
      ProviderContainer container,
      ) {
    if (newValue is AsyncError) {
      container
          .read(errorLoggerProvider)
          .logError(newValue.error, newValue.stackTrace);
    }
  }

  // TODO: Check if we can use this func instead of the [didUpdateProvider]
  @override
  void providerDidFail(
      ProviderBase<Object?> provider,
      Object error,
      StackTrace stackTrace,
      ProviderContainer container,
      ) {
    // container.read(errorLoggerProvider).logError(error, stackTrace);
  }
}
