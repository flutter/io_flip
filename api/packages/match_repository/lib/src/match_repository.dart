import 'dart:async';

import 'package:cards_repository/cards_repository.dart';
import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:gcloud_pubsub/gcloud_pubsub.dart';

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
    required GcloudPubsub gcloudPubsub,
    required bool isRunningLocally,
    this.trackPlayerPresence = true,
  })  : _cardsRepository = cardsRepository,
        _dbClient = dbClient,
        _gcloudPubsub = gcloudPubsub,
        _isRunningLocally = isRunningLocally,
        _matchSolver = matchSolver;

  final CardsRepository _cardsRepository;
  final DbClient _dbClient;
  final MatchSolver _matchSolver;
  final GcloudPubsub _gcloudPubsub;
  final bool _isRunningLocally;
  static const _cpuPrefix = 'CPU_';

  /// Configures whether we should actually track player presence or not.
  /// Used to disable the multiple tab check in staging.
  final bool trackPlayerPresence;

  /// Return the ScoreCard with the given [scoreCardId].
  Future<ScoreCard> getScoreCard(String scoreCardId, String deckId) async {
    final scoreData = await _dbClient.getById('score_cards', scoreCardId);

    if (scoreData == null) {
      await _dbClient.set(
        'score_cards',
        DbEntityRecord(
          id: scoreCardId,
          data: {
            'wins': 0,
            'currentStreak': 0,
            'longestStreak': 0,
            'currentDeck': deckId,
          },
        ),
      );
      return ScoreCard(id: scoreCardId, currentDeck: deckId);
    }

    final data = {...scoreData.data, 'id': scoreCardId};
    if (data['currentDeck'] != deckId) {
      data['currentStreak'] = 0;
    }
    data['currentDeck'] = deckId;
    return ScoreCard.fromJson(data);
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

  /// Push card to playing queue
  ///
  /// if [_isRunningLocally] is true then calls directly [playCard].
  Future<void> pushCardToQueue({
    required String matchId,
    required String cardId,
    required String deckId,
    required String userId,
  }) async {
    /* if (_isRunningLocally) {
      await playCard(
        matchId: matchId,
        cardId: cardId,
        deckId: deckId,
        userId: userId,
      );
    } else {*/
    await _gcloudPubsub.pushCardToQueue(
      matchId: matchId,
      cardId: cardId,
      deckId: deckId,
      userId: userId,
    );
    //}
  }

  /// Play a card on the given match.
  ///
  /// throws [PlayCardFailure] if the match state isn't found.
  Future<void> playCard({
    required String matchId,
    required String cardId,
    required String deckId,
    required String userId,
  }) async {
    final match = await getMatch(matchId);

    if (match == null) throw PlayCardFailure();

    final deck = await _cardsRepository.getDeck(deckId);

    if (deck == null || deck.userId != userId) throw PlayCardFailure();

    final matchState = await getMatchState(matchId);

    if (matchState == null) throw PlayCardFailure();

    final isHost = userId == match.hostDeck.userId;

    if (!_matchSolver.canPlayCard(matchState, cardId, isHost: isHost)) {
      throw PlayCardFailure();
    }

    var newMatchState = match.hostDeck.id == deckId
        ? matchState.addHostPlayedCard(cardId)
        : matchState.addGuestPlayedCard(cardId);

    if (newMatchState.isOver()) {
      final result = _matchSolver.calculateMatchResult(match, newMatchState);
      newMatchState = newMatchState.setResult(result);

      final host = await getScoreCard(match.hostDeck.userId, match.hostDeck.id);
      final guest = await getScoreCard(
        match.guestDeck.userId,
        match.guestDeck.id,
      );
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
          if (isHost)
            'hostPlayedCards': newMatchState.hostPlayedCards
          else
            'guestPlayedCards': newMatchState.guestPlayedCards,
          'result': newMatchState.result?.name,
        },
      ),
    );

    if (match.guestDeck.userId.contains(_cpuPrefix) &&
        newMatchState.guestPlayedCards.length < 3 &&
        newMatchState.guestPlayedCards.length <=
            newMatchState.hostPlayedCards.length) {
      unawaited(
        Future.delayed(const Duration(seconds: 1), () {
          playCard(
            matchId: matchId,
            cardId: match.guestDeck.cards
                .firstWhere(
                  (element) =>
                      !newMatchState.guestPlayedCards.contains(element.id),
                )
                .id,
            deckId: match.guestDeck.id,
            userId: match.guestDeck.userId,
          );
        }),
      );
    }
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
          'currentDeck': scoreCard.currentDeck,
          'longestStreakDeck': newStreak > scoreCard.longestStreak
              ? scoreCard.currentDeck
              : scoreCard.longestStreakDeck,
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

  /// Sets the `hostConnected` attribute on a match to true or false.
  Future<void> setHostConnectivity({
    required String match,
    required bool active,
  }) async {
    await _dbClient.update(
      'matches',
      DbEntityRecord(
        id: match,
        data: {
          'hostConnected': active,
        },
      ),
    );
  }

  /// Sets the `guestConnected` attribute on a match to true or false.
  Future<void> setGuestConnectivity({
    required String match,
    required bool active,
  }) async {
    await _dbClient.update(
      'matches',
      DbEntityRecord(
        id: match,
        data: {
          'guestConnected': active,
        },
      ),
    );
  }

  /// Sets the `guestConnected` attribute as true for CPU guest.
  Future<void> setCpuConnectivity({
    required String matchId,
    required String hostId,
  }) async {
    await _dbClient.update(
      'matches',
      DbEntityRecord(
        id: matchId,
        data: {
          'guestConnected': true,
          'guest': _cpuPrefix + hostId,
        },
      ),
    );
  }

  /// Return whether a player with the given [userId] is connected to the game.
  Future<bool> getPlayerConnectivity({required String userId}) async {
    final entity = await _dbClient.getById('connection_states', userId);

    return ((entity?.data['connected'] as bool?) ?? false) &&
        trackPlayerPresence;
  }

  /// Sets the player with the given [userId] as connected or disconnected.
  Future<void> setPlayerConnectivity({
    required String userId,
    required bool connected,
  }) async {
    await _dbClient.update(
      'connection_states',
      DbEntityRecord(
        id: userId,
        data: {
          'connected': connected,
        },
      ),
    );
  }
}
