// ignore_for_file: prefer_const_constructors

import 'package:api_client/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockHttpClient extends Mock {
  Future<http.Response> get(Uri uri);
  Future<http.Response> post(Uri uri, {Object? body});
  Future<http.Response> put(Uri uri, {Object? body});
}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri.parse('http://localhost'));
  });

  group('ApiClient', () {
    const baseUrl = 'http://baseurl.com';
    final expectedResponse = http.Response('{"data": "test"}', 200);
    late ApiClient subject;
    late _MockHttpClient httpClient;

    setUp(() {
      httpClient = _MockHttpClient();

      when(() => httpClient.get(any()))
          .thenAnswer((_) async => expectedResponse);

      when(() => httpClient.post(any(), body: any(named: 'body')))
          .thenAnswer((_) async => expectedResponse);

      when(() => httpClient.put(any(), body: any(named: 'body')))
          .thenAnswer((_) async => expectedResponse);

      subject = ApiClient(
        baseUrl: baseUrl,
        getCall: httpClient.get,
        postCall: httpClient.post,
        putCall: httpClient.put,
      );
    });

    test('can be instantiated', () {
      expect(
        ApiClient(baseUrl: 'http://localhost'),
        isNotNull,
      );
    });

    group('GameResource', () {
      test('returns a GameResource', () {
        expect(subject.gameResource, isA<GameResource>());
      });
    });

    group('ScriptsResource', () {
      test('returns a ScriptsResource', () {
        expect(subject.scriptsResource, isA<ScriptsResource>());
      });
    });

    group('get', () {
      test('returns the response', () async {
        final response = await subject.get('/');

        expect(response, equals(expectedResponse));
      });

      test('sends the request correctly', () async {
        await subject.get(
          '/path/to/endpoint',
          queryParameters: {
            'param1': 'value1',
            'param2': 'value2',
          },
        );

        verify(
          () => httpClient.get(
            Uri.parse('$baseUrl/path/to/endpoint?param1=value1&param2=value2'),
          ),
        ).called(1);
      });
    });

    group('post', () {
      test('returns the response', () async {
        final response = await subject.post('/');

        expect(response, equals(expectedResponse));
      });

      test('sends the request correctly', () async {
        await subject.post(
          '/path/to/endpoint',
          queryParameters: {'param1': 'value1', 'param2': 'value2'},
          body: 'BODY_CONTENT',
        );

        verify(
          () => httpClient.post(
            Uri.parse('$baseUrl/path/to/endpoint?param1=value1&param2=value2'),
            body: 'BODY_CONTENT',
          ),
        ).called(1);
      });
    });

    group('put', () {
      test('returns the response', () async {
        final response = await subject.put('/');

        expect(response, equals(expectedResponse));
      });

      test('sends the request correctly', () async {
        await subject.put(
          '/path/to/endpoint',
          body: 'BODY_CONTENT',
        );

        verify(
          () => httpClient.put(
            Uri.parse('$baseUrl/path/to/endpoint'),
            body: 'BODY_CONTENT',
          ),
        ).called(1);
      });
    });

    group('ApiClientError', () {
      test('toString returns the cause', () {
        expect(
          ApiClientError('Ops', StackTrace.empty).toString(),
          equals('Ops'),
        );
      });
    });
  });
}
