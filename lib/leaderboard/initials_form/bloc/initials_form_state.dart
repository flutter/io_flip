part of 'initials_form_bloc.dart';

class InitialsFormState extends Equatable with FormzMixin {
  InitialsFormState({
    Initials? initials,
  }) : initials = initials ?? Initials.pure();

  final Initials initials;

  InitialsFormState copyWith({
    Initials? initials,
  }) {
    return InitialsFormState(
      initials: initials ?? this.initials,
    );
  }

  @override
  List<Object> get props => [initials];

  @override
  List<FormzInput> get inputs => [initials];
}
