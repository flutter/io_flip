import 'package:cards_repository/cards_repository.dart';
import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';

/// Throw when getting a match fails.
class GetMatchFailure extends Error {}

/// Throw when adding a move to a match fails.
class PlayCardFailure extends Error {}

/// {@template match_repository}
/// Access to Match datasource
/// {@endtemplate}
class MatchRepository {
  /// {@macro match_repository}
  const MatchRepository({
    required CardsRepository cardsRepository,
    required DbClient dbClient,
    MatchSolver matchSolver = const MatchSolver(),
  })  : _cardsRepository = cardsRepository,
        _dbClient = dbClient,
        _matchSolver = matchSolver;

  final CardsRepository _cardsRepository;
  final DbClient _dbClient;
  final MatchSolver _matchSolver;

  /// Return the match with the given [matchId].
  Future<Match?> getMatch(String matchId) async {
    final matchData = await _dbClient.getById('matches', matchId);

    if (matchData == null) {
      return null;
    }

    final hostDeckId = matchData.data['host'] as String;
    final guestDeckId = matchData.data['guest'] as String;

    final decks = await Future.wait([
      _cardsRepository.getDeck(hostDeckId),
      _cardsRepository.getDeck(guestDeckId),
    ]);

    final matchDecks = decks.whereType<Deck>();
    if (matchDecks.length != decks.length) {
      throw GetMatchFailure();
    }

    return Match(
      id: matchData.id,
      hostDeck: matchDecks.first,
      guestDeck: matchDecks.last,
    );
  }

  Future<DbEntityRecord?> _findMatchStateByMatchId(String matchId) async {
    final result = await _dbClient.findBy(
      'match_states',
      'matchId',
      matchId,
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  /// Returns the match state from the given [matchId].
  Future<MatchState?> getMatchState(String matchId) async {
    final record = await _findMatchStateByMatchId(matchId);

    if (record != null) {
      return MatchState(
        id: record.id,
        matchId: matchId,
        hostPlayedCards:
            (record.data['hostPlayedCards'] as List).cast<String>(),
        guestPlayedCards:
            (record.data['guestPlayedCards'] as List).cast<String>(),
        result: MatchResult.valueOf(record.data['result'] as String?),
      );
    }

    return null;
  }

  /// Play a card on the given match.
  ///
  /// throws [PlayCardFailure] if the match state isn't found.
  Future<void> playCard({
    required String matchId,
    required String cardId,
    required bool isHost,
  }) async {
    final matchState = await getMatchState(matchId);

    if (matchState == null) {
      throw PlayCardFailure();
    }

    var newMatchState = isHost
        ? matchState.addHostPlayedCard(cardId)
        : matchState.addGuestPlayedCard(cardId);

    if (newMatchState.isOver()) {
      final match = await getMatch(newMatchState.matchId);
      if (match == null) {
        throw PlayCardFailure();
      }

      final result = _matchSolver.calculateMatchResult(match, newMatchState);
      newMatchState = newMatchState.setResult(result);
    }

    await _dbClient.update(
      'match_states',
      DbEntityRecord(
        id: newMatchState.id,
        data: {
          'matchId': matchId,
          'hostPlayedCards': newMatchState.hostPlayedCards,
          'guestPlayedCards': newMatchState.guestPlayedCards,
          'result': newMatchState.result?.name,
        },
      ),
    );
  }
}
