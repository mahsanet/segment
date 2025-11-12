import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:segment/src/l10n/l10n.dart';
import 'package:segment/src/shared/errors/app_exceptions.dart';
import 'package:segment/src/shared/errors/app_exceptions_messages.dart';
import 'package:segment/src/shared/presentation/snack_bar/app_snack_bar.dart';

extension AsyncValueUI<T> on AsyncValue<T> {
  String _getErrorMessage(BuildContext context, Object error) {
    return error is AppException
        ? error.message(context).trim()
        : context.l10n.anErrorHappened;
  }

  void _showSnackBar(
    BuildContext context, {
    required SnackBar snackBar,
  }) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  SnackBar _createErrorSnackBar(
    BuildContext context, {
    VoidCallback? onRetry,
    Duration? duration,
  }) {
    return AppSnackBar.error(
      message: _getErrorMessage(context, error!),
      onRetry: onRetry,
      duration: duration,
    );
  }

  /// Shows SnackBar in error style statically
  void showSnackBarOnError(
    BuildContext context, {
    VoidCallback? onRetry,
    Duration? duration,
  }) {
    if (!isLoading && hasError) {
      _showSnackBar(
        context,
        snackBar: _createErrorSnackBar(
          context,
          onRetry: onRetry,
          duration: duration,
        ),
      );
    }
  }

  /// Shows SnackBar in positive/error style dynamically based on value
  void showSnackBar(
    BuildContext context, {
    VoidCallback? onRetry,
    Duration? duration,
  }) {
    if (!context.mounted) return;

    if (!isLoading) {
      if (hasError) {
        _showSnackBar(
          context,
          snackBar: _createErrorSnackBar(
            context,
            onRetry: onRetry,
            duration: duration,
          ),
        );
      } else {
        _showSnackBar(
          context,
          snackBar: AppSnackBar.positive(message: value.toString()),
        );
      }
    }
  }
}
