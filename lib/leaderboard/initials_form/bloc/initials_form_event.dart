part of 'initials_form_bloc.dart';

abstract class InitialsFormEvent extends Equatable {
  const InitialsFormEvent();
}

class InitialsChanged extends InitialsFormEvent {
  const InitialsChanged({required this.initials});

  final String initials;

  @override
  List<Object> get props => [initials];
}

class InitialsSubmitted extends InitialsFormEvent {
  @override
  List<Object?> get props => [];
}
