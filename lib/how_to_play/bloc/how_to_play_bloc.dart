import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_flip/how_to_play/how_to_play.dart';

part 'how_to_play_event.dart';
part 'how_to_play_state.dart';

class HowToPlayBloc extends Bloc<HowToPlayEvent, HowToPlayState> {
  HowToPlayBloc() : super(const HowToPlayState()) {
    on<NextPageRequested>(_onNextPageRequested);
    on<PreviousPageRequested>(_onPreviousPageRequested);
  }

  void _onNextPageRequested(
    NextPageRequested event,
    Emitter<HowToPlayState> emit,
  ) {
    var wheelSuits = state.wheelSuits;
    final suitsWheelPositionEnd =
        HowToPlayState.steps.length + wheelSuits.length - 1;

    if ((state.position >= HowToPlayState.steps.length) &&
        (state.position < suitsWheelPositionEnd)) {
      wheelSuits = nextSuitsPositions();
    }
    final position = state.position + 1;
    emit(
      state.copyWith(
        position: position,
        wheelSuits: wheelSuits,
      ),
    );
  }

  void _onPreviousPageRequested(
    PreviousPageRequested event,
    Emitter<HowToPlayState> emit,
  ) {
    var wheelSuits = state.wheelSuits;
    if ((state.position > HowToPlayState.steps.length) &&
        (state.position < HowToPlayState.steps.length + wheelSuits.length)) {
      wheelSuits = previousSuitsPositions();
    }
    final position = state.position - 1;
    emit(
      state.copyWith(
        position: position,
        wheelSuits: wheelSuits,
      ),
    );
  }

  List<Suit> nextSuitsPositions() {
    final orderedSuits = [...state.wheelSuits];
    orderedSuits.add(orderedSuits.removeAt(0));

    return orderedSuits;
  }

  List<Suit> previousSuitsPositions() {
    final orderedSuits = [...state.wheelSuits];
    orderedSuits.insert(0, orderedSuits.removeLast());

    return orderedSuits;
  }
}
