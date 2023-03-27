import 'package:api_client/api_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';

part 'draft_event.dart';
part 'draft_state.dart';

class DraftBloc extends Bloc<DraftEvent, DraftState> {
  DraftBloc({
    required GameResource gameResource,
  })  : _gameResource = gameResource,
        super(const DraftState.initial()) {
    on<DeckRequested>(_onDeckRequested);
    on<NextCard>(_onNextCard);
    on<SelectCard>(_onSelectCard);
  }

  final GameResource _gameResource;

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
          (_) => _gameResource.generateCard(),
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
    final cards = _dismissTopCard();
    emit(state.copyWith(cards: cards));
  }

  void _onSelectCard(
    SelectCard event,
    Emitter<DraftState> emit,
  ) {
    final topCard = state.cards.first;

    final selectedCards = [
      ...state.selectedCards,
      topCard,
    ];

    final selectionCompleted = selectedCards.length == 3;

    final cards = selectionCompleted ? null : _dismissTopCard();

    emit(
      state.copyWith(
        cards: cards,
        selectedCards: selectedCards,
        status: selectionCompleted
            ? DraftStateStatus.deckSelected
            : DraftStateStatus.deckLoaded,
      ),
    );
  }

  List<Card> _dismissTopCard() {
    final cards = [...state.cards];

    final lastCard = cards.removeLast();
    cards.insert(0, lastCard);
    return cards;
  }
}
