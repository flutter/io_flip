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
typedef PostCall = Future<Response> Function(Uri);

/// {@template game_client}
/// Client to access the game api
/// {@endtemplate}
class GameClient {
  /// {@macro game_client}
  const GameClient({
    required String endpoint,
    PostCall postCall = post,
  }) : _endpoint = endpoint,
  _post = postCall;

  final String _endpoint;

  final PostCall _post;

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
    } catch(e) {
      throw GameClientError(
        'POST /cards returned invalid response "${response.body}"', 
      );
    }
  }
}
