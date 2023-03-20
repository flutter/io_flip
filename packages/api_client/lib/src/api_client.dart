import 'package:api_client/src/resources/resources.dart';
import 'package:http/http.dart' as http;

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
});

/// Definition of a put call used by this client.
typedef PutCall = Future<http.Response> Function(
  Uri, {
  Object? body,
});

/// Definition of a get call used by this client.
typedef GetCall = Future<http.Response> Function(Uri);

/// {@template api_client}
/// Client to access the api
/// {@endtemplate}
class ApiClient {
  /// {@macro api_client}
  ApiClient({
    required String baseUrl,
    PostCall postCall = http.post,
    PutCall putCall = http.put,
    GetCall getCall = http.get,
  })  : _base = Uri.parse(baseUrl),
        _post = postCall,
        _put = putCall,
        _get = getCall;

  final Uri _base;

  final PostCall _post;

  final PostCall _put;

  final GetCall _get;

  /// {@macro game_resource}
  late final GameResource gameResource = GameResource(apiClient: this);

  /// {@macro scripts_resource}
  late final ScriptsResource scriptsResource = ScriptsResource(apiClient: this);

  /// Sends a POST request to the specified [path] with the given [body].
  Future<http.Response> post(
    String path, {
    Object? body,
    Map<String, String>? queryParameters = const {},
  }) async {
    return _post(
      _base.replace(
        path: path,
        queryParameters: queryParameters,
      ),
      body: body,
    );
  }

  /// Sends a PUT request to the specified [path] with the given [body].
  Future<http.Response> put(
    String path, {
    Object? body,
  }) async {
    return _put(
      _base.replace(path: path),
      body: body,
    );
  }

  /// Sends a GET request to the specified [path].
  Future<http.Response> get(
    String path, {
    Map<String, String>? queryParameters = const {},
  }) async {
    return _get(
      _base.replace(
        path: path,
        queryParameters: queryParameters,
      ),
    );
  }
}
