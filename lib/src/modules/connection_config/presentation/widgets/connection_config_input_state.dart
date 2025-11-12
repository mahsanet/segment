import 'package:equatable/equatable.dart';

class ConnectionConfigInputState extends Equatable {
  final String input;
  final String? error;
  final bool isDisabled;

  const ConnectionConfigInputState({
    this.input = '',
    this.error,
    this.isDisabled = false,
  });

  ConnectionConfigInputState copyWith({
    String? input,
    String? error,
    bool? isDisabled,
  }) {
    return ConnectionConfigInputState(
      input: input ?? this.input,
      error: error,
      isDisabled: isDisabled ?? this.isDisabled,
    );
  }

  @override
  List<Object?> get props => [input, error, isDisabled];
}