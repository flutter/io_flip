import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_client/game_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:match_maker_repository/match_maker_repository.dart' hide Match;

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({
    required GameClient gameClient,
    required MatchMakerRepository matchMakerRepository,
    required this.isHost,
  })  : _gameClient = gameClient,
        _matchMakerRepository = matchMakerRepository,
        super(const MatchLoadingState()) {
    on<MatchRequested>(_onMatchRequested);
    on<PlayerPlayed>(_onPlayerPlayed);
    on<OponentPlayed>(_onOponentPlayed);
  }

  final GameClient _gameClient;
  final MatchMakerRepository _matchMakerRepository;
  final bool isHost;

  StreamSubscription<String>? _opponentSubscription;

  Future<void> _onMatchRequested(
    MatchRequested event,
    Emitter<GameState> emit,
  ) async {
    try {
      emit(const MatchLoadingState());

      final values = await Future.wait([
        _gameClient.getMatch(event.matchId),
        _gameClient.getMatchState(event.matchId),
      ]);

      final match = values.first as Match?;
      final matchState = values.last as MatchState?;

      if (match == null || matchState == null) {
        emit(const MatchLoadFailedState());
      } else {
        emit(
          MatchLoadedState(
            match: match,
            matchState: matchState,
            turns: const [],
          ),
        );

        final stream = isHost
            ? _matchMakerRepository.watchGuestCards(matchState.id)
            : _matchMakerRepository.watchHostCards(matchState.id);

        _opponentSubscription = stream.listen((id) {
          add(OponentPlayed(id));
        });
      }
    } catch (e, s) {
      addError(e, s);
      emit(const MatchLoadFailedState());
    }
  }

  Future<void> _onPlayerPlayed(
    PlayerPlayed event,
    Emitter<GameState> emit,
  ) async {
    if (state is MatchLoadedState) {
      final matchState = state as MatchLoadedState;
      await _gameClient.playCard(
        matchId: matchState.match.id,
        cardId: event.cardId,
        isHost: isHost,
      );

      // Improve this code for re use
      if (matchState.turns.isEmpty) {
        emit(
          matchState.copyWith(
            turns: [
              MatchTurn(
                playerCardId: event.cardId,
                oponentCardId: null,
              ),
            ],
          ),
        );
      } else {
        final lastTurn = matchState.turns.last;

        if (lastTurn.playerCardId == null) {
          final newTurn = lastTurn.copyWith(playerCardId: event.cardId);
          emit(
            matchState.copyWith(
              turns: matchState.turns
                  .map(
                    (turn) => turn == lastTurn ? newTurn : turn,
                  )
                  .toList(),
            ),
          );
        } else {
          emit(
            matchState.copyWith(
              turns: [
                ...matchState.turns,
                MatchTurn(
                  playerCardId: event.cardId,
                  oponentCardId: null,
                ),
              ],
            ),
          );
        }
      }
    }
  }

  Future<void> _onOponentPlayed(
    OponentPlayed event,
    Emitter<GameState> emit,
  ) async {
    if (state is MatchLoadedState) {
      final matchState = state as MatchLoadedState;

      if (matchState.turns.isEmpty) {
        emit(
          matchState.copyWith(
            turns: [
              MatchTurn(
                playerCardId: null,
                oponentCardId: event.cardId,
              ),
            ],
          ),
        );
      } else {
        final lastTurn = matchState.turns.last;

        if (lastTurn.oponentCardId == null) {
          final newTurn = lastTurn.copyWith(oponentCardId: event.cardId);

          emit(
            matchState.copyWith(
              turns: matchState.turns
                  .map(
                    (turn) => turn == lastTurn ? newTurn : turn,
                  )
                  .toList(),
            ),
          );
        } else {
          emit(
            matchState.copyWith(
              turns: [
                ...matchState.turns,
                MatchTurn(
                  playerCardId: null,
                  oponentCardId: event.cardId,
                ),
              ],
            ),
          );
        }
      }
    }
  }

  @override
  Future<void> close() {
    _opponentSubscription?.cancel();
    return super.close();
  }
}

extension MatchTurnX on MatchTurn {
  bool isComplete() {
    return playerCardId != null && oponentCardId != null;
  }
}

extension MatchLoadedStateX on MatchLoadedState {
  bool isCardTurnComplete(Card card) {
    for (final turn in turns) {
      if (card.id == turn.playerCardId || card.id == turn.oponentCardId) {
        return turn.isComplete();
      }
    }

    return false;
  }

  bool isWiningCard(Card card) {
    for (final turn in turns) {
      if ((card.id == turn.playerCardId || card.id == turn.oponentCardId) &&
          turn.isComplete()) {
        final allCards = {
          for (final card in match.hostDeck.cards) card.id: card.power,
          for (final card in match.guestDeck.cards) card.id: card.power,
        };

        final oponentId = card.id == turn.playerCardId
            ? turn.oponentCardId
            : turn.playerCardId;

        return (allCards[card.id] ?? 0) > (allCards[oponentId] ?? 0);
      }
    }
    return false;
  }
}
