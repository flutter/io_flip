import 'dart:math' as math;

import 'package:game_domain/game_domain.dart';
import 'package:game_script_machine/game_script_machine.dart';

/// {@template match_resolution_failure}
/// Throw when a round cannot be resolved.
/// {@endtemplate}
class MatchResolutionFailure implements Exception {
  /// {@macro match_resolution_failure}
  MatchResolutionFailure({
    required this.message,
    required this.stackTrace,
  });

  /// Message.
  final String message;

  /// StackTrace.
  final StackTrace stackTrace;
}

/// {@template match_solver}
/// A class with logic on how to solve match problems,
/// it includes methods to determine who won't the game
/// among other domain specific logic to matches.
/// {@endtemplate}
class MatchSolver {
  /// {@macro match_solver}
  const MatchSolver({
    required GameScriptMachine gameScriptMachine,
  }) : _gameScriptMachine = gameScriptMachine;

  final GameScriptMachine _gameScriptMachine;

  /// Calculates and return the result of a match.
  MatchResult calculateMatchResult(Match match, MatchState state) {
    if (!state.isOver()) {
      throw MatchResolutionFailure(
        message: "Can't calculate the result of a match that "
            "hasn't finished yet.",
        stackTrace: StackTrace.current,
      );
    }

    var hostRounds = 0;
    var guestRounds = 0;

    for (var i = 0; i < state.hostPlayedCards.length; i++) {
      final roundResult = calculateRoundResult(
        match,
        state,
        i,
      );

      if (roundResult == MatchResult.host) {
        hostRounds++;
      } else if (roundResult == MatchResult.guest) {
        guestRounds++;
      }
    }

    if (hostRounds == guestRounds) {
      return MatchResult.draw;
    } else {
      return hostRounds > guestRounds ? MatchResult.host : MatchResult.guest;
    }
  }

  /// Calculates and return result of a round of match.
  ///
  /// Throws [MatchResolutionFailure] when trying to solve a round
  /// that isn't finished yet.
  MatchResult calculateRoundResult(Match match, MatchState state, int round) {
    if (state.hostPlayedCards.length > round &&
        state.guestPlayedCards.length > round) {
    } else {
      throw MatchResolutionFailure(
        message: "Can't calculate the result of a round that "
            "hasn't finished yet.",
        stackTrace: StackTrace.current,
      );
    }

    final hostCardId = state.hostPlayedCards[round];
    final guestCardId = state.guestPlayedCards[round];

    final hostCard =
        match.hostDeck.cards.firstWhere((card) => card.id == hostCardId);
    final guestCard =
        match.guestDeck.cards.firstWhere((card) => card.id == guestCardId);

    final comparison = _gameScriptMachine.compare(hostCard, guestCard);
    if (comparison == 0) {
      return MatchResult.draw;
    } else {
      return comparison > 0 ? MatchResult.host : MatchResult.guest;
    }
  }

  /// Returns true when player, determined by [isHost], can select a card
  /// to play.
  bool isPlayerTurn(MatchState state, {required bool isHost}) {
    final hostStarts = state.hostStartsMatch;
    final isPlayer1 = (isHost && hostStarts) || (!isHost && !hostStarts);

    final hostPlayedCardsLength = state.hostPlayedCards.length;
    final guestPlayedCardsLength = state.guestPlayedCards.length;

    final player1PlayedCardsLength =
        hostStarts ? hostPlayedCardsLength : guestPlayedCardsLength;
    final player2PlayedCardsLength =
        hostStarts ? guestPlayedCardsLength : hostPlayedCardsLength;

    final round = math.min(hostPlayedCardsLength, guestPlayedCardsLength) + 1;

    if (round.isOdd) {
      if (isPlayer1 && player1PlayedCardsLength == player2PlayedCardsLength) {
        return true;
      }
      if (!isPlayer1 && player1PlayedCardsLength > player2PlayedCardsLength) {
        return true;
      }
    }

    if (round.isEven) {
      if (isPlayer1 && player1PlayedCardsLength < player2PlayedCardsLength) {
        return true;
      }
      if (!isPlayer1 && player1PlayedCardsLength == player2PlayedCardsLength) {
        return true;
      }
    }
    return false;
  }

  /// Returns true when player, determined by [isHost], can play the card
  /// with id [cardId] or if they need to either
  /// wait for their opponent to play first or play another card.
  bool canPlayCard(MatchState state, String cardId, {required bool isHost}) {
    if (isHost && state.hostPlayedCards.contains(cardId)) {
      return false;
    }

    if (!isHost && state.guestPlayedCards.contains(cardId)) {
      return false;
    }

    return isPlayerTurn(state, isHost: isHost);
  }
}
