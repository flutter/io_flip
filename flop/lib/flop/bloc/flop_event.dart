part of 'flop_bloc.dart';

abstract class FlopEvent extends Equatable {
  const FlopEvent();
}

class NextStepRequested extends FlopEvent {
  const NextStepRequested();

  @override
  List<Object> get props => [];
}
