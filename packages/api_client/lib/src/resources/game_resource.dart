import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:game_domain/game_domain.dart';

/// {@template game_resource}
/// An api resource for interacting with the game.
/// {@endtemplate}
class GameResource {
  /// {@macro game_resource}
  GameResource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  /// Post /cards
  Future<List<Card>> generateCards(Prompt prompt) async {
    final response = await _apiClient.post(
      '/game/cards',
      body: jsonEncode(prompt),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw ApiClientError(
        'POST /cards returned status ${response.statusCode} with the following response: "${response.body}"',
        StackTrace.current,
      );
    }

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final cards = json['cards'] as List<dynamic>;
      return cards
          .map(
            (card) => Card.fromJson(card as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw ApiClientError(
        'POST /cards returned invalid response "${response.body}"',
        StackTrace.current,
      );
    }
  }

  /// Post /decks
  ///
  /// Returns the id of the created deck.
  Future<String> createDeck(List<String> cardIds) async {
    final response = await _apiClient.post(
      '/game/decks',
      body: jsonEncode({'cards': cardIds}),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw ApiClientError(
        'POST /decks returned status ${response.statusCode} with the following response: "${response.body}"',
        StackTrace.current,
      );
    }

    try {
      final json = jsonDecode(response.body);
      return (json as Map<String, dynamic>)['id'] as String;
    } catch (e) {
      throw ApiClientError(
        'POST /decks returned invalid response "${response.body}"',
        StackTrace.current,
      );
    }
  }

  /// Get /decks/:deckId
  ///
  /// Returns a [Deck], if any to be found.
  Future<Deck?> getDeck(String deckId) async {
    final response = await _apiClient.get('/game/decks/$deckId');

    if (response.statusCode == HttpStatus.notFound) {
      return null;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw ApiClientError(
        'GET /decks/$deckId returned status ${response.statusCode} with the following response: "${response.body}"',
        StackTrace.current,
      );
    }

    try {
      final json = jsonDecode(response.body);
      return Deck.fromJson(json as Map<String, dynamic>);
    } catch (e) {
      throw ApiClientError(
        'GET /decks/$deckId returned invalid response "${response.body}"',
        StackTrace.current,
      );
    }
  }

  /// Get /matches/:matchId
  ///
  /// Returns a [Match], if any to be found.
  Future<Match?> getMatch(String matchId) async {
    final response = await _apiClient.get('/game/matches/$matchId');

    if (response.statusCode == HttpStatus.notFound) {
      return null;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw ApiClientError(
        'GET /matches/$matchId returned status ${response.statusCode} with the following response: "${response.body}"',
        StackTrace.current,
      );
    }

    try {
      final json = jsonDecode(response.body);
      return Match.fromJson(json as Map<String, dynamic>);
    } catch (e) {
      throw ApiClientError(
        'GET /matches/$matchId returned invalid response "${response.body}"',
        StackTrace.current,
      );
    }
  }

  /// Get /matches/:matchId/state
  ///
  /// Returns a [MatchState], if any to be found.
  Future<MatchState?> getMatchState(String matchId) async {
    final response = await _apiClient.get('/game/matches/$matchId/state');

    if (response.statusCode == HttpStatus.notFound) {
      return null;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw ApiClientError(
        'GET /matches/$matchId/state returned status ${response.statusCode} with the following response: "${response.body}"',
        StackTrace.current,
      );
    }

    try {
      final json = jsonDecode(response.body);
      return MatchState.fromJson(json as Map<String, dynamic>);
    } catch (e) {
      throw ApiClientError(
        'GET /matches/$matchId/state returned invalid response "${response.body}"',
        StackTrace.current,
      );
    }
  }

  /// Plays a card
  ///
  /// Post /matches/:matchId/state/move
  Future<void> playCard({
    required String matchId,
    required String cardId,
    required String deckId,
  }) async {
    try {
      final response = await _apiClient
          .post('/game/matches/$matchId/decks/$deckId/cards/$cardId');

      if (response.statusCode != HttpStatus.noContent) {
        throw ApiClientError(
          'POST /matches/$matchId/decks/$deckId/cards/$cardId returned status ${response.statusCode} with the following response: "${response.body}"',
          StackTrace.current,
        );
      }
    } on ApiClientError {
      rethrow;
    } catch (e) {
      throw ApiClientError(
        'POST /matches/$matchId/decks/$deckId/cards/$cardId failed with the following message: "$e"',
        StackTrace.current,
      );
    }
  }

  /// Get the result of a match
  ///
  /// Get /matches/:matchId/result
  Future<void> calculateResult({
    required String matchId,
  }) async {
    try {
      final response = await _apiClient.get('/game/matches/$matchId/result');

      if (response.statusCode != HttpStatus.ok) {
        throw ApiClientError(
          'GET /matches/$matchId/result returned status ${response.statusCode} with the following response: "${response.body}"',
          StackTrace.current,
        );
      }
    } on ApiClientError {
      rethrow;
    } catch (e) {
      throw ApiClientError(
        'GET /matches/$matchId/result failed with the following message: "$e"',
        StackTrace.current,
      );
    }
  }

  /// WebSocket connect to  game/matches/connect
  Future<void> connectToCpuMatch({
    required String matchId,
  }) async {
    try {
      final response = await _apiClient.post(
        '/game/matches/$matchId/connect',
      );

      if (response.statusCode != HttpStatus.noContent) {
        throw ApiClientError(
          'POST game/matches/connect returned status ${response.statusCode} with the following response: "${response.body}"',
          StackTrace.current,
        );
      }
    } on ApiClientError {
      rethrow;
    } catch (error) {
      throw ApiClientError(
        'POST game/matches/connect returned with the following error: "$error"',
        StackTrace.current,
      );
    }
  }
}
