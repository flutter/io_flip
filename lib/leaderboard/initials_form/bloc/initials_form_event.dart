part of 'initials_form_bloc.dart';

abstract class InitialsFormEvent extends Equatable {
  const InitialsFormEvent();
}

class InitialsChanged extends InitialsFormEvent {
  const InitialsChanged({required this.initial, required this.index});

  final String initial;
  final int index;

  @override
  List<Object> get props => [initial, index];
}

class InitialsSubmitted extends InitialsFormEvent {
  @override
  List<Object?> get props => [];
}
