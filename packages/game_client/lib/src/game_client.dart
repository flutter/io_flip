import 'dart:convert';
import 'dart:io';

import 'package:game_domain/game_domain.dart';
import 'package:http/http.dart';

/// {@template game_client_error}
/// Error throw when accessing a game api failed.
///
/// Check [cause] and [stackTrace] for specific details.
/// {@endtemplate}
class GameClientError implements Exception {
  /// {@macro game_client_error}
  GameClientError(this.cause, this.stackTrace);

  /// Error cause.
  final dynamic cause;

  /// The stack trace of the error.
  final StackTrace stackTrace;

  @override
  String toString() {
    return cause.toString();
  }
}

/// Definition of a post call used by this client.
typedef PostCall = Future<Response> Function(Uri, {Object? body});

/// Definition of a put call used by this client.
typedef PutCall = Future<Response> Function(Uri, {Object? body});

/// Definition of a get call used by this client.
typedef GetCall = Future<Response> Function(Uri);

/// {@template game_client}
/// Client to access the game api
/// {@endtemplate}
class GameClient {
  /// {@macro game_client}
  const GameClient({
    required String endpoint,
    PostCall postCall = post,
    PutCall putCall = put,
    GetCall getCall = get,
  })  : _endpoint = endpoint,
        _post = postCall,
        _put = putCall,
        _get = getCall;

  final String _endpoint;

  final PostCall _post;

  final PostCall _put;

  final GetCall _get;

  /// Post /cards
  Future<Card> generateCard() async {
    final response = await _post(Uri.parse('$_endpoint/cards'));

    if (response.statusCode != HttpStatus.ok) {
      throw GameClientError(
        'POST /cards returned status ${response.statusCode} with the following response: "${response.body}"',
        StackTrace.current,
      );
    }

    try {
      final json = jsonDecode(response.body);
      return Card.fromJson(json as Map<String, dynamic>);
    } catch (e) {
      throw GameClientError(
        'POST /cards returned invalid response "${response.body}"',
        StackTrace.current,
      );
    }
  }

  /// Post /decks
  ///
  /// Returns the id of the created deck.
  Future<String> createDeck({
    required List<String> cardIds,
    required String userId,
  }) async {
    final response = await _post(
      Uri.parse('$_endpoint/decks'),
      body: jsonEncode({
        'cards': cardIds,
        'userId': userId,
      }),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw GameClientError(
        'POST /decks returned status ${response.statusCode} with the following response: "${response.body}"',
        StackTrace.current,
      );
    }

    try {
      final json = jsonDecode(response.body);
      return (json as Map<String, dynamic>)['id'] as String;
    } catch (e) {
      throw GameClientError(
        'POST /decks returned invalid response "${response.body}"',
        StackTrace.current,
      );
    }
  }

  /// Get /decks/:deckId
  ///
  /// Returns a [Deck], if any to be found.
  Future<Deck?> getDeck(String deckId) async {
    final response = await _get(
      Uri.parse('$_endpoint/decks/$deckId'),
    );

    if (response.statusCode == HttpStatus.notFound) {
      return null;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw GameClientError(
        'GET /decks/$deckId returned status ${response.statusCode} with the following response: "${response.body}"',
        StackTrace.current,
      );
    }

    try {
      final json = jsonDecode(response.body);
      return Deck.fromJson(json as Map<String, dynamic>);
    } catch (e) {
      throw GameClientError(
        'GET /decks/$deckId returned invalid response "${response.body}"',
        StackTrace.current,
      );
    }
  }

  /// Get /matches/:matchId
  ///
  /// Returns a [Match], if any to be found.
  Future<Match?> getMatch(String matchId) async {
    final response = await _get(
      Uri.parse('$_endpoint/matches/$matchId'),
    );

    if (response.statusCode == HttpStatus.notFound) {
      return null;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw GameClientError(
        'GET /matches/$matchId returned status ${response.statusCode} with the following response: "${response.body}"',
        StackTrace.current,
      );
    }

    try {
      final json = jsonDecode(response.body);
      return Match.fromJson(json as Map<String, dynamic>);
    } catch (e) {
      throw GameClientError(
        'GET /matches/$matchId returned invalid response "${response.body}"',
        StackTrace.current,
      );
    }
  }

  /// Get /matches/:matchId/state
  ///
  /// Returns a [MatchState], if any to be found.
  Future<MatchState?> getMatchState(String matchId) async {
    final response = await _get(
      Uri.parse('$_endpoint/matches/state?matchId=$matchId'),
    );

    if (response.statusCode == HttpStatus.notFound) {
      return null;
    }

    if (response.statusCode != HttpStatus.ok) {
      throw GameClientError(
        'GET /matches/$matchId/state returned status ${response.statusCode} with the following response: "${response.body}"',
        StackTrace.current,
      );
    }

    try {
      final json = jsonDecode(response.body);
      return MatchState.fromJson(json as Map<String, dynamic>);
    } catch (e) {
      throw GameClientError(
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
    required String userId,
  }) async {
    try {
      final response = await _post(
        Uri.parse(
          '$_endpoint/matches/move?matchId=$matchId&cardId=$cardId&deckId=$deckId&userId=$userId',
        ),
      );

      if (response.statusCode != HttpStatus.noContent) {
        throw GameClientError(
          'POST /matches/$matchId/move returned status ${response.statusCode} with the following response: "${response.body}"',
          StackTrace.current,
        );
      }
    } on GameClientError {
      rethrow;
    } catch (e) {
      throw GameClientError(
        'POST /matches/$matchId/move failed with the following message: "$e"',
        StackTrace.current,
      );
    }
  }

  /// Get /scripts/current
  Future<String> getCurrentScript() async {
    final response = await _get(Uri.parse('$_endpoint/scripts/current'));

    if (response.statusCode != HttpStatus.ok) {
      throw GameClientError(
        'GET /scripts/current returned status ${response.statusCode} with the following response: "${response.body}"',
        StackTrace.current,
      );
    }

    return response.body;
  }

  /// Put /scripts/:id
  Future<void> updateScript(String id, String content) async {
    final response =
        await _put(Uri.parse('$_endpoint/scripts/$id'), body: content);

    if (response.statusCode != HttpStatus.noContent) {
      throw GameClientError(
        'PUT /scripts/$id returned status ${response.statusCode} with the following response: "${response.body}"',
        StackTrace.current,
      );
    }
  }
}
