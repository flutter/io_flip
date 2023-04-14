import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:top_dash/how_to_play/how_to_play.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

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
    var wheelElements = state.wheelElements;
    if (state.position >= HowToPlayState.initialSteps.length) {
      wheelElements = nextElementsPositions();
    }
    final position = state.position + 1;
    emit(
      state.copyWith(
        position: position,
        wheelElements: wheelElements,
      ),
    );
  }

  void _onPreviousPageRequested(
    PreviousPageRequested event,
    Emitter<HowToPlayState> emit,
  ) {
    var wheelElements = state.wheelElements;
    if (state.position > HowToPlayState.initialSteps.length) {
      wheelElements = previousElementsPositions();
    }
    final position = state.position - 1;
    emit(
      state.copyWith(
        position: position,
        wheelElements: wheelElements,
      ),
    );
  }

  List<Elements> nextElementsPositions() {
    final orderedElements = [...state.wheelElements];
    orderedElements.add(orderedElements.removeAt(0));

    return orderedElements;
  }

  List<Elements> previousElementsPositions() {
    final orderedElements = [...state.wheelElements];
    orderedElements.insert(0, orderedElements.removeLast());

    return orderedElements;
  }
}
