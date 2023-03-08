import 'package:game_domain/game_domain.dart';

/// {@template match_solver}
/// A class with logic on how to solve match problems,
/// it includes methods to determine who won't the game
/// among other domain specific logic to matches.
/// {@endtemplate}
class MatchSolver {
  /// {@macro match_solver}
  const MatchSolver();

  /// Calculates and return the result of a match.
  MatchResult calculateMatchResult(Match match, MatchState state) {
    final cardsList = [...match.hostDeck.cards, ...match.guestDeck.cards];
    final allCards = {
      for (final card in cardsList) card.id: card,
    };

    var hostRounds = 0;
    var guestRounds = 0;

    for (var i = 0; i < state.hostPlayedCards.length; i++) {
      final hostCardPower = allCards[state.hostPlayedCards[i]]?.power ?? 0;
      final guestCardPower = allCards[state.guestPlayedCards[i]]?.power ?? 0;

      if (hostCardPower > guestCardPower) {
        hostRounds++;
      } else if (guestCardPower > hostCardPower) {
        guestRounds++;
      }
    }

    if (hostRounds == guestRounds) {
      return MatchResult.draw;
    } else {
      return hostRounds > guestRounds ? MatchResult.host : MatchResult.guest;
    }
  }
}
