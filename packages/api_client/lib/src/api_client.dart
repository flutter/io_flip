import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api_client/src/resources/resources.dart';
import 'package:encrypt/encrypt.dart';
import 'package:game_domain/game_domain.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_client/web_socket_client.dart';

/// {@template api_client_error}
/// Error throw when accessing api failed.
///
/// Check [cause] and [stackTrace] for specific details.
/// {@endtemplate}
class ApiClientError implements Exception {
  /// {@macro api_client_error}
  ApiClientError(this.cause, this.stackTrace);

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
typedef PostCall = Future<http.Response> Function(
  Uri, {
  Object? body,
  Map<String, String>? headers,
});

/// Definition of a put call used by this client.
typedef PutCall = Future<http.Response> Function(
  Uri, {
  Object? body,
  Map<String, String>? headers,
});

/// Definition of a get call used by this client.
typedef GetCall = Future<http.Response> Function(
  Uri, {
  Map<String, String>? headers,
});

/// A factory to create and connect to a [WebSocket] instance.
typedef WebSocketFactory = WebSocket Function(
  Uri uri, {
  Duration? timeout,
  String? binaryType,
});

/// {@template api_client}
/// Client to access the api
/// {@endtemplate}
class ApiClient {
  /// {@macro api_client}
  ApiClient({
    required String baseUrl,
    required Stream<String?> idTokenStream,
    required Future<String?> Function() refreshIdToken,
    required Stream<String?> appCheckTokenStream,
    String? appCheckToken,
    PostCall postCall = http.post,
    PutCall putCall = http.put,
    GetCall getCall = http.get,
    WebSocketFactory webSocketFactory = WebSocket.new,
    Duration webSocketTimeout = const Duration(seconds: 20),
  })  : _base = Uri.parse(baseUrl),
        _post = postCall,
        _put = putCall,
        _get = getCall,
        _webSocketFactory = webSocketFactory,
        _webSocketTimeout = webSocketTimeout,
        _appCheckToken = appCheckToken,
        _refreshIdToken = refreshIdToken {
    _idTokenSubscription = idTokenStream.listen((idToken) {
      _idToken = idToken;
    });
    _appCheckTokenSubscription = appCheckTokenStream.listen((appCheckToken) {
      _appCheckToken = appCheckToken;
    });
  }

  final Uri _base;
  final PostCall _post;
  final PostCall _put;
  final GetCall _get;
  final Future<String?> Function() _refreshIdToken;
  final WebSocketFactory _webSocketFactory;
  final Duration _webSocketTimeout;

  late final StreamSubscription<String?> _idTokenSubscription;
  late final StreamSubscription<String?> _appCheckTokenSubscription;
  String? _idToken;
  String? _appCheckToken;

  Map<String, String> get _headers => {
        if (_idToken != null) 'Authorization': 'Bearer $_idToken',
        if (_appCheckToken != null) 'X-Firebase-AppCheck': _appCheckToken!,
      };

  /// {@macro game_resource}
  late final GameResource gameResource = GameResource(apiClient: this);

  /// {@macro share_resource}
  late final ShareResource shareResource = ShareResource(apiClient: this);

  /// {@macro prompt_resource}
  late final PromptResource promptResource = PromptResource(apiClient: this);

  /// {@macro scripts_resource}
  late final ScriptsResource scriptsResource = ScriptsResource(apiClient: this);

  /// {@macro leaderboard_resource}
  late final LeaderboardResource leaderboardResource =
      LeaderboardResource(apiClient: this);

  Future<http.Response> _handleUnauthorized(
    Future<http.Response> Function() sendRequest,
  ) async {
    final response = await sendRequest();

    if (response.statusCode == HttpStatus.unauthorized) {
      _idToken = await _refreshIdToken();
      return sendRequest();
    }
    return response;
  }

  /// Dispose of resources used by this client.
  Future<void> dispose() async {
    await _idTokenSubscription.cancel();
    await _appCheckTokenSubscription.cancel();
  }

  /// Sends a POST request to the specified [path] with the given [body].
  Future<http.Response> post(
    String path, {
    Object? body,
    Map<String, String>? queryParameters,
  }) async {
    return _handleUnauthorized(() async {
      final response = await _post(
        _base.replace(
          path: path,
          queryParameters: queryParameters,
        ),
        body: body,
        headers: _headers,
      );

      return response.decrypted;
    });
  }

  /// Sends a PUT request to the specified [path] with the given [body].
  Future<http.Response> put(
    String path, {
    Object? body,
  }) async {
    return _handleUnauthorized(() async {
      final response = await _put(
        _base.replace(path: path),
        body: body,
        headers: _headers,
      );

      return response.decrypted;
    });
  }

  /// Sends a GET request to the specified [path].
  Future<http.Response> get(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    return _handleUnauthorized(() async {
      final response = await _get(
        _base.replace(
          path: path,
          queryParameters: queryParameters,
        ),
        headers: _headers,
      );

      return response.decrypted;
    });
  }

  /// Returns a WebSocket for the specified [path].
  Future<WebSocket> connect(String path) async {
    final uri = _base.replace(
      scheme: _base.scheme.replaceAll('http', 'ws'),
      path: path,
    );

    try {
      final webSocket = _webSocketFactory(
        uri,
        timeout: _webSocketTimeout,
        binaryType: 'blob',
      );
      if (_idToken != null) {
        webSocket
          ..onConnected(
            () => webSocket.send(jsonEncode(WebSocketMessage.token(_idToken!))),
          )
          ..onReconnected(
            () => webSocket.send(
              jsonEncode(
                WebSocketMessage.token(
                  _idToken!,
                  reconnect: true,
                ),
              ),
            ),
          );
      }

      return webSocket;
    } catch (error) {
      throw ApiClientError(
        'WebSocket: $path returned with the following error: "$error"',
        StackTrace.current,
      );
    }
  }

  /// Returns the share page url for the specified [deckId].
  String shareHandUrl(String deckId) {
    return '${_base.host}/public/share?deckId=$deckId';
  }

  /// Returns the share page url for the specified [cardId].
  String shareCardUrl(String cardId) {
    return '${_base.host}/public/share?cardId=$cardId';
  }

  /// Returns the game url.
  String shareGameUrl() {
    return _base.host;
  }
}

extension on http.Response {
  http.Response get decrypted {
    if (body.isEmpty) return this;

    final key = Key.fromUtf8(_encryptionKey);
    final iv = IV.fromUtf8(_encryptionIV);

    final encrypter = Encrypter(AES(key));

    final decrypted = encrypter.decrypt64(body, iv: iv);

    return http.Response(
      jsonDecode(decrypted).toString(),
      statusCode,
      headers: headers,
      isRedirect: isRedirect,
      persistentConnection: persistentConnection,
      reasonPhrase: reasonPhrase,
      request: request,
    );
  }

  String get _encryptionKey {
    const value = String.fromEnvironment(
      'ENCRYPTION_KEY',
      // Default value is set at 32 characters to match required length of
      // AES key. The default value can then be used for testing purposes.
      defaultValue: 'encryption_key_not_set_123456789',
    );
    return value;
  }

  String get _encryptionIV {
    const value = String.fromEnvironment(
      'ENCRYPTION_IV',
      // Default value is set at 116 characters to match required length of
      // IV key. The default value can then be used for testing purposes.
      defaultValue: 'iv_not_set_12345',
    );
    return value;
  }
}

extension on WebSocket {
  void onConnected(void Function() onConnected) {
    connection.firstWhere((state) => state is Connected).then((_) {
      onConnected();
    });
  }

  void onReconnected(void Function() onReconnected) {
    connection.where((state) => state is Reconnected).forEach((_) {
      onReconnected();
    });
  }
}
