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
  })  : _cardsRepository = cardsRepository,
        _dbClient = dbClient;

  final CardsRepository _cardsRepository;
  final DbClient _dbClient;

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
    final record = await _findMatchStateByMatchId(matchId);

    if (record == null) {
      throw PlayCardFailure();
    }

    final key = isHost
        ? 'hostPlayedCards'
        : 'guestPlayedCards';

    (record.data[key] as List).add(cardId);

    await _dbClient.update('match_states', record);
  }
}
