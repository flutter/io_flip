import 'dart:convert';
import 'dart:io';

import 'package:grpc/grpc.dart' hide Response;
import 'package:http/http.dart';

/// {@template gcloud_pubsub_failure}
///
/// {@endtemplate}
class GcloudPubsubFailure implements Exception {
  /// {@macro gcloud_pubsub_failure}
  const GcloudPubsubFailure(this.message, this.stackTrace);

  /// The error message.
  final String message;

  /// The stack trace.
  final StackTrace stackTrace;

  @override
  String toString() => message;
}

/// A function that builds an [HttpBasedAuthenticator].
typedef AuthenticatorBuilder = Future<HttpBasedAuthenticator> Function(
  List<String> scopes,
);

/// A function that posts a request to a URL.
typedef PostCall = Future<Response> Function(
  Uri uri, {
  Map<String, String>? headers,
  dynamic body,
});

/// {@template gcloud_pubsub}
/// Allows played card to be pushed to a topic queue.
///
/// Throws a [GcloudPubsubFailure] if the request fails.
/// {@endtemplate}
class GcloudPubsub {
  /// {@macro gcloud_pubsub}
  const GcloudPubsub({
    AuthenticatorBuilder authenticatorBuilder =
        applicationDefaultCredentialsAuthenticator,
    PostCall postCall = post,
  })  : _authenticatorBuilder = authenticatorBuilder,
        _post = postCall;

  final AuthenticatorBuilder _authenticatorBuilder;
  static const String _projectId = 'top-dash-dev';
  final PostCall _post;

  /// Pushes played card to queue.
  Future<void> pushCardToQueue({
    required String matchId,
    required String cardId,
    required String deckId,
    required String userId,
  }) async {
    const url =
        'https://pubsub.googleapis.com/v1/projects/$_projectId/topics/playCard:publish';

    final headers = await _authenticate(url);

    final response = await _post(
      Uri.parse(url),
      body: jsonEncode({
        "messages": [
          {"data": base64.encode(utf8.encode('{"card": "cardId"}'))}
        ]
      }),
      headers: {
        ...headers,
      },
    );

    if (response.statusCode != HttpStatus.ok) {
      throw GcloudPubsubFailure(
        response.body,
        StackTrace.current,
      );
    }
  }

  Future<Map<String, String>> _authenticate(String uri) async {
    final delegate = await _authenticatorBuilder([
      'https://www.googleapis.com/auth/pubsub',
    ]);

    final metadata = <String, String>{};
    await delegate.authenticate(metadata, uri);

    return metadata;
  }
}
