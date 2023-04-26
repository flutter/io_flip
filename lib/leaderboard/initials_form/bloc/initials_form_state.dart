part of 'initials_form_bloc.dart';

enum InitialsFormStatus {
  initial,
  valid,
  invalid,
  blacklisted,
  success,
  failure;

  bool get isInvalid => this == InitialsFormStatus.invalid;
  bool get isBlacklisted => this == InitialsFormStatus.blacklisted;
}

class InitialsFormState extends Equatable {
  const InitialsFormState({
    String? initials,
    this.status = InitialsFormStatus.initial,
  }) : initials = initials ?? '';

  final String initials;
  final InitialsFormStatus status;

  InitialsFormState copyWith({
    String? initials,
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
