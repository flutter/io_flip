import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';

/// {@template leaderboard_resource}
/// An api resource for interacting with the leaderboard.
/// {@endtemplate}
class LeaderboardResource {
  /// {@macro leaderboard_resource}
  LeaderboardResource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  /// Get /game/leaderboard/initials_blacklist
  ///
  /// Returns a [List<String>].
  Future<List<String>> getInitialsBlacklist() async {
    final response =
        await _apiClient.get('/game/leaderboard/initials_blacklist');

    if (response.statusCode == HttpStatus.notFound) {
      return [];
    }

    if (response.statusCode != HttpStatus.ok) {
      throw ApiClientError(
        'GET /leaderboard/initials_blacklist returned status ${response.statusCode} with the following response: "${response.body}"',
        StackTrace.current,
      );
    }

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return (json['list'] as List).cast<String>();
    } catch (e) {
      throw ApiClientError(
        'GET /leaderboard/initials_blacklist returned invalid response "${response.body}"',
        StackTrace.current,
      );
    }
  }

  /// Post /game/leaderboard/initials
  Future<void> addInitialsToScoreCard({
    required String scoreCardId,
    required String initials,
  }) async {
    final response = await _apiClient.post(
      '/game/leaderboard/initials',
      body: jsonEncode({
        'scoreCardId': scoreCardId,
        'initials': initials,
      }),
    );

    if (response.statusCode != HttpStatus.noContent) {
      throw ApiClientError(
        'POST /leaderboard/initials returned status ${response.statusCode} with the following response: "${response.body}"',
        StackTrace.current,
      );
    }
  }
}
