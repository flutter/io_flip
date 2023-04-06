import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';

/// {@template leaderboard_repository}
/// Access to Leaderboard datasource.
/// {@endtemplate}
class LeaderboardRepository {
  /// {@macro leaderboard_repository}
  const LeaderboardRepository({
    required DbClient dbClient,
    required String blacklistDocumentId,
  })  : _dbClient = dbClient,
        _blacklistDocumentId = blacklistDocumentId;

  final DbClient _dbClient;
  final String _blacklistDocumentId;

  /// Retrieves the blacklist for player initials.
  Future<List<String>> getInitialsBlacklist() async {
    final blacklistData = await _dbClient.getById(
      'initials_blacklist',
      _blacklistDocumentId,
    );

    if (blacklistData == null) {
      return [];
    }

    return (blacklistData.data['blacklist'] as List).cast<String>();
  }

  /// Retrieves the score card where the longest streak deck matches
  /// the given [deckId].
  Future<ScoreCard?> findScoreCardByLongestStreakDeck(String deckId) async {
    final results = await _dbClient.findBy(
      'score_cards',
      'longestStreakDeck',
      deckId,
    );

    if (results.isEmpty) {
      return null;
    }

    return ScoreCard.fromJson({
      'id': results.first.id,
      ...results.first.data,
    });
  }

  /// Checks whether the given [initials] is available.
  ///
  /// Returns `true` if no score cards were found, `false` otherwise.
  Future<bool> isInitialsAvailable(String initials) async {
    final results = await _dbClient.findBy(
      'score_cards',
      'initials',
      initials,
    );

    return results.isEmpty;
  }

  /// Adds the initials to the score card with the given [scoreCardId].
  Future<void> addInitialsToScoreCard({
    required String scoreCardId,
    required String initials,
  }) async {
    await _dbClient.update(
      'score_cards',
      DbEntityRecord(
        id: scoreCardId,
        data: {
          'initials': initials,
        },
      ),
    );
  }
}
