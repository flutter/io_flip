// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockHttpClient extends Mock {
  Future<http.Response> get(Uri uri, {Map<String, String>? headers});
  Future<http.Response> post(
    Uri uri, {
    Object? body,
    Map<String, String>? headers,
  });
  Future<http.Response> put(
    Uri uri, {
    Object? body,
    Map<String, String>? headers,
  });
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
    late StreamController<String?> idTokenStreamController;

    Future<String?> Function() refreshIdToken = () async => null;

    setUp(() {
      httpClient = _MockHttpClient();

      when(
        () => httpClient.get(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => expectedResponse);

      when(
        () => httpClient.post(
          any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => expectedResponse);

      when(
        () => httpClient.put(
          any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => expectedResponse);

      idTokenStreamController = StreamController();

      subject = ApiClient(
        baseUrl: baseUrl,
        getCall: httpClient.get,
        postCall: httpClient.post,
        putCall: httpClient.put,
        idTokenStream: idTokenStreamController.stream,
        refreshIdToken: () => refreshIdToken(),
      );
    });

    test('can be instantiated', () {
      expect(
        ApiClient(
          baseUrl: 'http://localhost',
          idTokenStream: Stream.empty(),
          refreshIdToken: () async => null,
        ),
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

    group('dispose', () {
      test('cancels id token stream subscription', () {
        expect(idTokenStreamController.hasListener, isTrue);

        subject.dispose();

        expect(idTokenStreamController.hasListener, isFalse);
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
            headers: {},
          ),
        ).called(1);
      });

      test('sends the authentication token', () async {
        idTokenStreamController.add('myToken');
        await Future.microtask(() {});
        await subject.get('/path/to/endpoint');

        verify(
          () => httpClient.get(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer myToken',
            },
          ),
        ).called(1);
      });

      test('refreshes the authentication token when needed', () async {
        when(
          () => httpClient.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => http.Response('', 401));

        refreshIdToken = () async => 'newToken';

        idTokenStreamController.add('myToken');
        await Future.microtask(() {});

        await subject.get('/path/to/endpoint');

        verify(
          () => httpClient.get(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer myToken',
            },
          ),
        ).called(1);
        verify(
          () => httpClient.get(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer newToken',
            },
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
            headers: {},
          ),
        ).called(1);
      });

      test('sends the authentication token', () async {
        idTokenStreamController.add('myToken');
        await Future.microtask(() {});
        await subject.post('/path/to/endpoint');

        verify(
          () => httpClient.post(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer myToken',
            },
          ),
        ).called(1);
      });

      test('refreshes the authentication token when needed', () async {
        when(
          () => httpClient.post(
            any(),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => http.Response('', 401));

        refreshIdToken = () async => 'newToken';

        idTokenStreamController.add('myToken');
        await Future.microtask(() {});

        await subject.post('/path/to/endpoint');

        verify(
          () => httpClient.post(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer myToken',
            },
          ),
        ).called(1);
        verify(
          () => httpClient.post(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer newToken',
            },
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
            headers: {},
          ),
        ).called(1);
      });

      test('sends the authentication token', () async {
        idTokenStreamController.add('myToken');
        await Future.microtask(() {});
        await subject.put('/path/to/endpoint');

        verify(
          () => httpClient.put(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer myToken',
            },
          ),
        ).called(1);
      });

      test('refreshes the authentication token when needed', () async {
        when(
          () => httpClient.put(
            any(),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => http.Response('', 401));

        refreshIdToken = () async => 'newToken';

        idTokenStreamController.add('myToken');
        await Future.microtask(() {});

        await subject.put('/path/to/endpoint');

        verify(
          () => httpClient.put(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer myToken',
            },
          ),
        ).called(1);
        verify(
          () => httpClient.put(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer newToken',
            },
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
