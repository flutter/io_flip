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
    required MatchSolver matchSolver,
  })  : _cardsRepository = cardsRepository,
        _dbClient = dbClient,
        _matchSolver = matchSolver;

  final CardsRepository _cardsRepository;
  final DbClient _dbClient;
  final MatchSolver _matchSolver;

  /// Return the ScoreCard with the given [scoreCardId].
  Future<ScoreCard> getScoreCard(String scoreCardId) async {
    final scoreData = await _dbClient.getById('score_cards', scoreCardId);

    if (scoreData == null) {
      await _dbClient.create(
        'score_cards',
        DbEntityRecord(
          id: scoreCardId,
          data: const {
            'wins': 0,
            'currentStreak': 0,
            'longestStreak': 0,
          },
        ),
      );
      return ScoreCard(id: scoreCardId);
    }

    final data = scoreData.data;

    return ScoreCard(
      id: scoreCardId,
      wins: data['wins'] as int,
      currentStreak: data['currentStreak'] as int,
      longestStreak: data['longestStreak'] as int,
    );
  }

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

      final host = await getScoreCard(match.hostDeck.userId);
      final guest = await getScoreCard(match.guestDeck.userId);
      if (result == MatchResult.host) {
        await _playerWon(host);
        await _playerLost(guest);
      } else if (result == MatchResult.guest) {
        await _playerWon(guest);
        await _playerLost(host);
      }
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

  Future<void> _playerWon(ScoreCard scoreCard) async {
    var newStreak = scoreCard.longestStreak;
    if (scoreCard.currentStreak + 1 > scoreCard.longestStreak) {
      newStreak = scoreCard.currentStreak + 1;
    }

    await _dbClient.update(
      'score_cards',
      DbEntityRecord(
        id: scoreCard.id,
        data: {
          'wins': scoreCard.wins + 1,
          'currentStreak': scoreCard.currentStreak + 1,
          'longestStreak': newStreak,
        },
      ),
    );
  }

  Future<void> _playerLost(ScoreCard scoreCard) async {
    await _dbClient.update(
      'score_cards',
      DbEntityRecord(
        id: scoreCard.id,
        data: const {
          'currentStreak': 0,
        },
      ),
    );
  }
}
