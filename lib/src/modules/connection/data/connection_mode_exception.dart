part of 'package:segment/src/shared/errors/app_exceptions.dart';
// ignore_for_file: must_be_immutable
class ConnectionModeException extends AppException {
  final int value;

  ConnectionModeException(this.value) : super(additionalData: "Value: $value");
}
