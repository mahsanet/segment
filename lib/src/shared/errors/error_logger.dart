import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:segment/src/shared/errors/app_exceptions.dart';

//ignore: depend_on_referenced_packages
import 'package:stack_trace/stack_trace.dart' as stack_trace;

final errorLoggerProvider = Provider.autoDispose((ref) => ErrorLogger());

class ErrorLogger {

  Future<void> logError(Object error, StackTrace? stackTrace) async {
    if (error is AppException) {
      await logAppException(error);
    } else {
      debugPrint('$error, $stackTrace');
    }
  }

  Future<void> logAppException(AppException exception) async {
    if (exception.isLogged) {
      return;
    }
    log(
      '''
       ------------------------------------------------------------------------
       type: ${exception.runtimeType}:
       error: ${exception.error}
       additional data: ${exception.additionalData}
       stackTrace: ${customStackTrace(exception.stackTrace ?? exception.defaultStackTrace)}
       ------------------------------------------------------------------------
      ''',
    );

    /// sets [AppException.isLogged] flag to true so it doesn't get logged again
    exception.logged();
  }

  String customStackTrace(StackTrace stackTrace) {
    return stack_trace.Trace.from(stackTrace)
        .terse
        .toString()
        .split('\n')
        .where((frame) {
      return !frame.contains('package:flutter') &&
          !frame.contains('<asynchronous suspension>');
    }).join('\n');
  }
}
