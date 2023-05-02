import 'dart:io';

import 'package:mocktail/mocktail.dart';

T mockFailedNetworkImages<T>(T Function() body) {
  return HttpOverrides.runZoned(
    body,
    createHttpClient: (_) => _createErrorHttpClient(),
  );
}

class _MockHttpClient extends Mock implements HttpClient {
  _MockHttpClient() {
    registerFallbackValue((List<int> _) {});
    registerFallbackValue(Uri());
  }

  @override
  // ignore: avoid_setters_without_getters, no_leading_underscores_for_local_identifiers
  set autoUncompress(bool _autoUncompress) {}
}

class _MockHttpClientRequest extends Mock implements HttpClientRequest {}

class _MockHttpClientResponse extends Mock implements HttpClientResponse {}

class _MockHttpHeaders extends Mock implements HttpHeaders {}

HttpClient _createErrorHttpClient() {
  final client = _MockHttpClient();
  final request = _MockHttpClientRequest();
  final response = _MockHttpClientResponse();
  final headers = _MockHttpHeaders();
  when(() => response.statusCode).thenReturn(HttpStatus.internalServerError);
  when(() => request.headers).thenReturn(headers);
  when(request.close).thenAnswer((_) async => response);
  when(() => client.getUrl(any())).thenAnswer((_) async => request);
  return client;
}
