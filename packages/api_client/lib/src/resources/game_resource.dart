import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:web_socket_client/web_socket_client.dart';

/// {@template game_resource}
/// An api resource for interacting with the game.
/// {@endtemplate}
class GameResource {
  /// {@macro game_resource}
  GameResource({
    required ApiClient apiClient,
    WebSocket? websocket,
  })  : _apiClient = apiClient,
        _websocket = websocket;

  final ApiClient _apiClient;
  final WebSocket? _websocket;

  /// Post /cards
  Future<Card> generateCard() async {
    final response = await _apiClient.post('/cards');

    if (response.statusCode != HttpStatus.ok) {
      throw ApiClientError(
        'POST /cards returned status ${response.statusCode} with the following response: "${response.body}"',
        StackTrace.current,
      );
    }

    try {
      final json = jsonDecode(response.body);
      return Card.fromJson(json as Map<String, dynamic>);
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
      '/decks',
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
    final response = await _apiClient.get('/decks/$deckId');

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
    final response = await _apiClient.get('/matches/$matchId');

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
    final response = await _apiClient.get('/matches/$matchId/state');

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
          .post('/matches/$matchId/decks/$deckId/cards/$cardId');

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

  /// Webhook connect to  matches/connect/
  Future<WebSocket> connectToMatch({
    required String matchId,
    required bool isHost,
  }) async {
    try {
      final uri = _apiClient.getWebsocketURI(
        '/matches/connect',
        queryParameters: {
          'matchId': matchId,
          'host': isHost.toString(),
        },
      );
      final socket = _websocket ?? WebSocket(uri);

      await socket.connection.firstWhere((state) => state is Connected);

      return socket;
    } catch (error) {
      throw ApiClientError(
        'websocket matches/connect/ returned with the following error: "$error"',
        StackTrace.current,
      );
    }
  }
}
