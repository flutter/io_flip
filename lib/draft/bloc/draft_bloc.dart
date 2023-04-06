import 'package:api_client/api_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';
import 'package:top_dash/audio/audio_controller.dart';
import 'package:top_dash/gen/assets.gen.dart';

part 'draft_event.dart';
part 'draft_state.dart';

class DraftBloc extends Bloc<DraftEvent, DraftState> {
  DraftBloc({
    required GameResource gameResource,
    required AudioController audioController,
  })  : _gameResource = gameResource,
        _audioController = audioController,
        super(const DraftState.initial()) {
    on<DeckRequested>(_onDeckRequested);
    on<PreviousCard>(_onPreviousCard);
    on<NextCard>(_onNextCard);
    on<CardSwiped>(_onCardSwiped);
    on<CardSwipeStarted>(_onCardSwipeStarted);
    on<SelectCard>(_onSelectCard);
  }

  final GameResource _gameResource;
  final AudioController _audioController;

  Future<void> _onDeckRequested(
    DeckRequested event,
    Emitter<DraftState> emit,
  ) async {
    try {
      emit(state.copyWith(status: DraftStateStatus.deckLoading));

      final cards = await _gameResource.generateCards(event.prompts);

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

  void _onPreviousCard(
    PreviousCard event,
    Emitter<DraftState> emit,
  ) {
    final cards = _retrieveLastCard();
    emit(state.copyWith(cards: cards));
  }

  void _onNextCard(
    NextCard event,
    Emitter<DraftState> emit,
  ) {
    final cards = _dismissTopCard();
    emit(state.copyWith(cards: cards));
  }

  void _onCardSwiped(
    CardSwiped event,
    Emitter<DraftState> emit,
  ) {
    final cards = _dismissTopCard();
    emit(
      state.copyWith(
        cards: cards,
        firstCardOpacity: 1,
      ),
    );
  }

  void _onCardSwipeStarted(
    CardSwipeStarted event,
    Emitter<DraftState> emit,
  ) {
    final opacity = 1 - event.progress;
    emit(state.copyWith(firstCardOpacity: opacity));
  }

  void _onSelectCard(
    SelectCard event,
    Emitter<DraftState> emit,
  ) {
    if (state.selectedCards.length == 3) return;

    _audioController.playSfx(Assets.sfx.addToHand);

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

    final firstCard = cards.removeAt(0);
    cards.add(firstCard);
    return cards;
  }

  List<Card> _retrieveLastCard() {
    final cards = [...state.cards];

    final lastCard = cards.removeLast();
    cards.insert(0, lastCard);
    return cards;
  }
}
