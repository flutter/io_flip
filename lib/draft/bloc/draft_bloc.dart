import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_client/game_client.dart';
import 'package:game_domain/game_domain.dart';

part 'draft_event.dart';
part 'draft_state.dart';

class DraftBloc extends Bloc<DraftEvent, DraftState> {
  DraftBloc({
    required GameClient gameClient,
  })  : _gameClient = gameClient,
        super(const DraftState.initial()) {
          on<CardRequested>(_onCardRequested);
        }

  final GameClient _gameClient;

  Future<void> _onCardRequested(
    CardRequested event,
    Emitter<DraftState> emit,
  ) async {
    try {
      emit(state.copyWith(status: DraftStateStatus.cardLoading));
      final card = await _gameClient.generateCard();
      final cards = [
        ...state.cards,
        card,
      ];
      emit(
        state.copyWith(
          cards: cards,
          status: cards.length == 3
              ? DraftStateStatus.deckCompleted
              : DraftStateStatus.cardLoaded,
        ),
      );
    } catch (e, s) {
      addError(e, s);
      emit(state.copyWith(status: DraftStateStatus.cardFailed));
    }
  }
}
