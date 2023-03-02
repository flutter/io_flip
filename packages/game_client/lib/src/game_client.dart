import 'dart:convert';
import 'dart:io';

import 'package:game_domain/game_domain.dart';
import 'package:http/http.dart';

/// {@template game_client_error}
/// Error throw when accessing a game api failed.
///
/// Check [cause] and [stackTrace] for specific details.
/// {@endtemplate}
class GameClientError extends Error {
  /// {@macro game_client_error}
  GameClientError(this.cause);

  /// Error cause.
  final dynamic cause;
}

/// Definition of a post call used by this client.
typedef PostCall = Future<Response> Function(Uri, {Object? body});

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
    GetCall getCall = get,
  })  : _endpoint = endpoint,
        _post = postCall,
        _get = getCall;

  final String _endpoint;

  final PostCall _post;

  final GetCall _get;

  /// Post /cards
  Future<Card> generateCard() async {
    final response = await _post(Uri.parse('$_endpoint/cards'));

    if (response.statusCode != HttpStatus.ok) {
      throw GameClientError(
        'POST /cards returned status ${response.statusCode} with the following response: "${response.body}"',
      );
    }

    try {
      final json = jsonDecode(response.body);
      return Card.fromJson(json as Map<String, dynamic>);
    } catch (e) {
      throw GameClientError(
        'POST /cards returned invalid response "${response.body}"',
      );
    }
  }

  /// Post /decks
  ///
  /// Returns the id of the created deck.
  Future<String> createDeck(List<String> cardIds) async {
    final response = await _post(
      Uri.parse('$_endpoint/decks'),
      body: jsonEncode({'cards': cardIds}),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw GameClientError(
        'POST /decks returned status ${response.statusCode} with the following response: "${response.body}"',
      );
    }

    try {
      final json = jsonDecode(response.body);
      return (json as Map<String, dynamic>)['id'] as String;
    } catch (e) {
      throw GameClientError(
        'POST /decks returned invalid response "${response.body}"',
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
      );
    }

    try {
      final json = jsonDecode(response.body);
      return Deck.fromJson(json as Map<String, dynamic>);
    } catch (e) {
      throw GameClientError(
        'GET /decks/$deckId returned invalid response "${response.body}"',
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
      );
    }

    try {
      final json = jsonDecode(response.body);
      return Match.fromJson(json as Map<String, dynamic>);
    } catch (e) {
      throw GameClientError(
        'GET /matches/$matchId returned invalid response "${response.body}"',
      );
    }
  }
}
