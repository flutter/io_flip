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
    on<DeckRequested>(_onDeckRequested);
    on<NextCard>(_onNextCard);
    on<SelectCard>(_onSelectCard);
  }

  final GameClient _gameClient;

  Future<void> _onDeckRequested(
    DeckRequested event,
    Emitter<DraftState> emit,
  ) async {
    try {
      emit(state.copyWith(status: DraftStateStatus.deckLoading));

      const deckSize = 10;
      final cards = await Future.wait(
        List.generate(
          deckSize,
          (_) => _gameClient.generateCard(),
        ),
      );

      emit(
        state.copyWith(
          cards: cards,
          status: DraftStateStatus.deckLoaded,
        ),
      );
    } catch (e, s) {
      addError(e, s);
      emit(state.copyWith(status: DraftStateStatus.deckFailed));
    }
  }

  void _onNextCard(
    NextCard event,
    Emitter<DraftState> emit,
  ) {
    final cards = [...state.cards];

    final lastCard = cards.removeLast();
    cards.insert(0, lastCard);

    emit(state.copyWith(cards: cards));
  }

  void _onSelectCard(
    SelectCard event,
    Emitter<DraftState> emit,
  ) {
    final lastCard = state.cards.last;

    final selectedCards = [
      ...state.selectedCards,
      lastCard,
    ];

    emit(
      state.copyWith(
        selectedCards: selectedCards,
        status: selectedCards.length == 3
            ? DraftStateStatus.deckSelected
            : DraftStateStatus.deckLoaded,
      ),
    );
  }
}
