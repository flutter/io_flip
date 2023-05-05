import 'package:api_client/api_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_flip/asset_manager/asset_manager.dart';
import 'package:io_flip/audio/audio_controller.dart';
import 'package:io_flip/gen/assets.gen.dart';

part 'draft_event.dart';
part 'draft_state.dart';

class DraftBloc extends Bloc<DraftEvent, DraftState> {
  DraftBloc({
    required GameResource gameResource,
    required AudioController audioController,
    required AssetManager assetManager,
  })  : _gameResource = gameResource,
        _audioController = audioController,
        _assetManager = assetManager,
        super(const DraftState.initial()) {
    on<DeckRequested>(_onDeckRequested);
    on<PreviousCard>(_onPreviousCard);
    on<NextCard>(_onNextCard);
    on<CardSwiped>(_onCardSwiped);
    on<CardSwipeStarted>(_onCardSwipeStarted);
    on<SelectCard>(_onSelectCard);
    on<PlayerDeckRequested>(_onPlayerDeckRequested);
  }

  final GameResource _gameResource;
  final AudioController _audioController;
  final AssetManager _assetManager;

  final List<String> _playedHoloReveal = [];

  Future<void> _onDeckRequested(
    DeckRequested event,
    Emitter<DraftState> emit,
  ) async {
    try {
      emit(state.copyWith(status: DraftStateStatus.deckLoading));

      final cards = await _gameResource.generateCards(event.prompts);
      // We don't allow the user to move on while there are assets loading.
      await _assetManager.ready;

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

    final oldSelectedCard = state.selectedCards[event.index];
    final selectedCards = List.of(state.selectedCards);
    selectedCards[event.index] = topCard;

    final selectionCompleted =
        selectedCards.length == 3 && !selectedCards.contains(null);

    final cards = [
      ...state.cards.skip(1),
      if (oldSelectedCard != null) oldSelectedCard,
    ];
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

  Future<void> _onPlayerDeckRequested(
    PlayerDeckRequested event,
    Emitter<DraftState> emit,
  ) async {
    try {
      emit(state.copyWith(status: DraftStateStatus.deckLoading));
      final deckId = await _gameResource.createDeck(event.cardIds);
      // TODO(jaime): refactor create deck call to return the full deck
      final deck = await _gameResource.getDeck(deckId);
      emit(
        state.copyWith(
          deck: deck,
          status: DraftStateStatus.playerDeckCreated,
          createPrivateMatch: event.createPrivateMatch,
          privateMatchInviteCode: event.privateMatchInviteCode,
        ),
      );
    } catch (e, s) {
      addError(e, s);
      emit(state.copyWith(status: DraftStateStatus.playerDeckFailed));
    }
  }
}
