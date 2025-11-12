import 'package:flutter/material.dart';
import 'package:segment/src/shared/errors/app_exceptions.dart';

extension AppExceptionExtensions on AppException {
  String message(BuildContext context) => switch (this) {
        /// Developer errors
        InvalidTypeException() => 'Invalid type',

        /// Important exceptions
        ParseAddressException() => 'There was an error in parsing address',
        HttpException() =>
          'There was an error in connecting to server. Please check your internet connection.',
        RequestException(:final statusCode) =>
          'Request failed with status code $statusCode',
        JsonDecodeException() =>
          'There was an error in parsing server response',
        JsonToDtoException() => 'There was an error in parsing server response',
        FakeTestException() => 'test exception',
        SameAddressException() =>
          'You are trying to transact with your own account',
        LocalAuthException() =>
          'Error in trying to authenticate with biometrics: $error',
        SharedPreferencesException() =>
          'There was an error in reading preferences',
        ParseRequestPayloadException() =>
          'There was an error in parsing request payload',
        ConnectionModeException(:final value) =>
          'Unknown connection mode. value: $value',
        CoreException() => '$error',
        ConnectionMetaException() => "Connection Meta Failed: $error",
        NoConfigException() =>
          'No connection configuration found. Please set up a config first.',
      };
}
