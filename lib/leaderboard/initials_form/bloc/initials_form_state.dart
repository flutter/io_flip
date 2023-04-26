part of 'initials_form_bloc.dart';

enum InitialsFormStatus {
  initial,
  valid,
  invalid,
  blacklisted,
  success,
  failure;

  bool get isInvalid => this == InitialsFormStatus.invalid;
}

class InitialsFormState extends Equatable {
  const InitialsFormState({
    List<String>? initials,
    this.status = InitialsFormStatus.initial,
  }) : initials = initials ?? const ['', '', ''];

  final List<String> initials;
  final InitialsFormStatus status;

  InitialsFormState copyWith({
    List<String>? initials,
    InitialsFormStatus? status,
  }) {
    return InitialsFormState(
      initials: initials ?? this.initials,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [initials, status];
}
