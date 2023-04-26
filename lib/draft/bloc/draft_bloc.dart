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

  final List<String> _playedHoloReveal = [];

  Future<void> _onDeckRequested(
    DeckRequested event,
    Emitter<DraftState> emit,
  ) async {
    try {
      emit(state.copyWith(status: DraftStateStatus.deckLoading));

      // final cards = await _gameResource.generateCards(event.prompts);
      final cards = [
        Card(
          id: '1',
          name: 'Card 1',
          description: 'This card is super powerful',
          image: 'image',
          power: 2,
          rarity: true,
          suit: Suit.air,
        ),
        Card(
          id: '2',
          name: 'Card 2',
          description: 'This card is super powerful',
          image: 'image',
          power: 2,
          rarity: true,
          suit: Suit.fire,
        ),
        Card(
          id: '3',
          name: 'Card 3',
          description: 'This card is super powerful',
          image: 'image',
          power: 2,
          rarity: false,
          suit: Suit.fire,
        ),
        Card(
          id: '4',
          name: 'Card 4',
          description: 'This card is super powerful',
          image: 'image',
          power: 2,
          rarity: false,
          suit: Suit.fire,
        ),
      ];

      emit(
        state.copyWith(
          cards: cards,
          status: DraftStateStatus.deckLoaded,
        ),
      );
      _audioController.playSfx(Assets.sfx.reveal);
      _playHoloReveal(cards);
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
    _playHoloReveal(cards);
    emit(state.copyWith(cards: cards));
  }

  void _onNextCard(
    NextCard event,
    Emitter<DraftState> emit,
  ) {
    final cards = _dismissTopCard();
    _playHoloReveal(cards);
    emit(state.copyWith(cards: cards));
  }

  void _onCardSwiped(
    CardSwiped event,
    Emitter<DraftState> emit,
  ) {
    final cards = _dismissTopCard();
    _playHoloReveal(cards);
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
    _audioController.playSfx(Assets.sfx.cardMovement);
    final opacity = 1 - event.progress;
    emit(state.copyWith(firstCardOpacity: opacity));
  }

  void _onSelectCard(
    SelectCard event,
    Emitter<DraftState> emit,
  ) {
    final topCard = state.cards.first;
    if (state.selectedCards.contains(topCard)) return;
    _audioController.playSfx(Assets.sfx.addToHand);

    final selectedCards = List.of(state.selectedCards);
    selectedCards[event.index] = topCard;

    final selectionCompleted =
        selectedCards.length == 3 && !selectedCards.contains(null);

    final cards = _dismissTopCard();
    _playHoloReveal(cards);

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

  void _playHoloReveal(List<Card> cards) {
    final card = cards.first;

    if (card.rarity && !_playedHoloReveal.contains(card.id)) {
      _playedHoloReveal.add(card.id);
      _audioController.playSfx(Assets.sfx.holoReveal);
    }
  }
}
