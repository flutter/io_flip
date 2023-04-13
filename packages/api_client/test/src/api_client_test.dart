// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:api_client/api_client.dart';
import 'package:encrypt/encrypt.dart';
import 'package:game_domain/game_domain.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:web_socket_client/web_socket_client.dart';

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

class _FakeConnection extends Fake implements Connection {
  _FakeConnection(this.stream);

  final Stream<ConnectionState> stream;

  @override
  Future<ConnectionState> firstWhere(
    bool Function(ConnectionState element) test, {
    ConnectionState Function()? orElse,
  }) =>
      stream.firstWhere(test, orElse: orElse);
}

class _MockWebSocket extends Mock implements WebSocket {}

class _MockWebSocketFactory extends Mock {
  WebSocket call(Uri uri);
}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri.parse('http://localhost'));
  });

  group('ApiClient', () {
    const baseUrl = 'http://baseurl.com';
    const webSocketTimeout = Duration(milliseconds: 200);
    const mockIdToken = 'mockIdToken';
    const mockNewIdToken = 'mockNewIdToken';
    const mockAppCheckToken = 'mockAppCheckToken';

    // Since the key and iv are set from the environment variables, we can
    // reference the default values here.
    final key = Key.fromUtf8('encryption_key_not_set_123456789');
    final iv = IV.fromUtf8('iv_not_set_12345');
    final encrypter = Encrypter(AES(key));

    final testJson = {'data': 'test'};

    final encrypted = encrypter.encrypt(jsonEncode(testJson), iv: iv).base64;

    final encryptedResponse = http.Response(encrypted, 200);
    final expectedResponse = http.Response(testJson.toString(), 200);

    late ApiClient subject;
    late _MockHttpClient httpClient;
    late StreamController<String?> idTokenStreamController;
    late StreamController<String?> appCheckTokenStreamController;
    late WebSocketFactory webSocketFactory;
    late WebSocket webSocket;
    late StreamController<ConnectionState> connectionStreamController;

    Future<String?> Function() refreshIdToken = () async => null;

    setUp(() {
      httpClient = _MockHttpClient();

      when(
        () => httpClient.get(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => encryptedResponse);

      when(
        () => httpClient.post(
          any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => encryptedResponse);

      when(
        () => httpClient.put(
          any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => encryptedResponse);

      idTokenStreamController = StreamController.broadcast();
      appCheckTokenStreamController = StreamController.broadcast();

      webSocketFactory = _MockWebSocketFactory().call;
      connectionStreamController = StreamController.broadcast();
      webSocket = _MockWebSocket();
      when(() => webSocket.connection).thenAnswer(
        (_) => _FakeConnection(connectionStreamController.stream),
      );
      when(() => webSocketFactory(any())).thenReturn(webSocket);

      subject = ApiClient(
        baseUrl: baseUrl,
        getCall: httpClient.get,
        postCall: httpClient.post,
        putCall: httpClient.put,
        idTokenStream: idTokenStreamController.stream,
        refreshIdToken: () => refreshIdToken(),
        appCheckTokenStream: appCheckTokenStreamController.stream,
        webSocketFactory: webSocketFactory.call,
        webSocketTimeout: webSocketTimeout,
      );
    });

    test('can be instantiated', () {
      expect(
        ApiClient(
          baseUrl: 'http://localhost',
          idTokenStream: Stream.empty(),
          refreshIdToken: () async => null,
          appCheckTokenStream: Stream.empty(),
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
      test('cancels id token stream subscription', () async {
        expect(idTokenStreamController.hasListener, isTrue);
        expect(appCheckTokenStreamController.hasListener, isTrue);

        await subject.dispose();

        expect(idTokenStreamController.hasListener, isFalse);
        expect(appCheckTokenStreamController.hasListener, isFalse);
      });
    });

    group('get', () {
      test('returns the response', () async {
        final response = await subject.get('/');

        expect(response.statusCode, equals(expectedResponse.statusCode));
        expect(response.body, equals(expectedResponse.body));
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

      test('sends the authentication and app check token', () async {
        idTokenStreamController.add(mockIdToken);
        appCheckTokenStreamController.add(mockAppCheckToken);
        await Future.microtask(() {});
        await subject.get('/path/to/endpoint');

        verify(
          () => httpClient.get(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer $mockIdToken',
              'X-Firebase-AppCheck': mockAppCheckToken
            },
          ),
        ).called(1);
      });

      test(
        'refreshes the authentication token when needed',
        () async {
          when(
            () => httpClient.get(
              any(),
              headers: any(named: 'headers'),
            ),
          ).thenAnswer((_) async => http.Response('', 401));

          refreshIdToken = () async => mockNewIdToken;

          idTokenStreamController.add(mockIdToken);
          appCheckTokenStreamController.add(mockAppCheckToken);
          await Future.microtask(() {});
          await subject.get('/path/to/endpoint');

          verify(
            () => httpClient.get(
              Uri.parse('$baseUrl/path/to/endpoint'),
              headers: {
                'Authorization': 'Bearer $mockIdToken',
                'X-Firebase-AppCheck': mockAppCheckToken,
              },
            ),
          ).called(1);
          verify(
            () => httpClient.get(
              Uri.parse('$baseUrl/path/to/endpoint'),
              headers: {
                'Authorization': 'Bearer $mockNewIdToken',
                'X-Firebase-AppCheck': mockAppCheckToken,
              },
            ),
          ).called(1);
        },
      );
    });

    group('post', () {
      test('returns the response', () async {
        final response = await subject.post('/');

        expect(response.statusCode, equals(expectedResponse.statusCode));
        expect(response.body, equals(expectedResponse.body));
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

      test('sends the authentication and app check token', () async {
        idTokenStreamController.add(mockIdToken);
        appCheckTokenStreamController.add(mockAppCheckToken);
        await Future.microtask(() {});
        await subject.post('/path/to/endpoint');

        verify(
          () => httpClient.post(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer $mockIdToken',
              'X-Firebase-AppCheck': mockAppCheckToken,
            },
          ),
        ).called(1);
      });

      test(
        'refreshes the authentication token when needed',
        () async {
          when(
            () => httpClient.post(
              any(),
              headers: any(named: 'headers'),
            ),
          ).thenAnswer((_) async => http.Response('', 401));

          refreshIdToken = () async => mockNewIdToken;

          idTokenStreamController.add(mockIdToken);
          appCheckTokenStreamController.add(mockAppCheckToken);
          await Future.microtask(() {});
          await subject.post('/path/to/endpoint');

          verify(
            () => httpClient.post(
              Uri.parse('$baseUrl/path/to/endpoint'),
              headers: {
                'Authorization': 'Bearer $mockIdToken',
                'X-Firebase-AppCheck': mockAppCheckToken,
              },
            ),
          ).called(1);
          verify(
            () => httpClient.post(
              Uri.parse('$baseUrl/path/to/endpoint'),
              headers: {
                'Authorization': 'Bearer $mockNewIdToken',
                'X-Firebase-AppCheck': mockAppCheckToken,
              },
            ),
          ).called(1);
        },
      );
    });

    group('put', () {
      test('returns the response', () async {
        final response = await subject.put('/');

        expect(response.statusCode, equals(expectedResponse.statusCode));
        expect(response.body, equals(expectedResponse.body));
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

      test('sends the authentication and app check token', () async {
        idTokenStreamController.add(mockIdToken);
        appCheckTokenStreamController.add(mockAppCheckToken);
        await Future.microtask(() {});
        await subject.put('/path/to/endpoint');

        verify(
          () => httpClient.put(
            Uri.parse('$baseUrl/path/to/endpoint'),
            headers: {
              'Authorization': 'Bearer $mockIdToken',
              'X-Firebase-AppCheck': mockAppCheckToken,
            },
          ),
        ).called(1);
      });

      test(
        'refreshes the authentication token when needed',
        () async {
          when(
            () => httpClient.put(
              any(),
              headers: any(named: 'headers'),
            ),
          ).thenAnswer((_) async => http.Response('', 401));

          refreshIdToken = () async => mockNewIdToken;

          idTokenStreamController.add(mockIdToken);
          appCheckTokenStreamController.add(mockAppCheckToken);
          await Future.microtask(() {});
          await subject.put('/path/to/endpoint');

          verify(
            () => httpClient.put(
              Uri.parse('$baseUrl/path/to/endpoint'),
              headers: {
                'Authorization': 'Bearer $mockIdToken',
                'X-Firebase-AppCheck': mockAppCheckToken,
              },
            ),
          ).called(1);
          verify(
            () => httpClient.put(
              Uri.parse('$baseUrl/path/to/endpoint'),
              headers: {
                'Authorization': 'Bearer $mockNewIdToken',
                'X-Firebase-AppCheck': mockAppCheckToken,
              },
            ),
          ).called(1);
        },
      );
    });

    group('ws connect', () {
      const path = '/path';

      setUp(() {
        connectionStreamController.onListen = () {
          connectionStreamController.add(Connected());
        };
      });

      test('returns the connection with a "ws" scheme for http', () async {
        final response = await subject.connect(path);
        expect(response, equals(webSocket));

        verify(
          () => webSocketFactory(
            Uri.parse('ws://baseurl.com/path'),
          ),
        ).called(1);
      });

      test('returns the connection with a "wss" scheme for https', () async {
        subject = ApiClient(
          baseUrl: baseUrl.replaceAll('http', 'https'),
          getCall: httpClient.get,
          postCall: httpClient.post,
          putCall: httpClient.put,
          idTokenStream: idTokenStreamController.stream,
          refreshIdToken: () => refreshIdToken(),
          appCheckTokenStream: appCheckTokenStreamController.stream,
          webSocketFactory: webSocketFactory.call,
        );

        final response = await subject.connect(path);
        expect(response, equals(webSocket));

        verify(
          () => webSocketFactory(
            Uri.parse('wss://baseurl.com/path'),
          ),
        ).called(1);
      });

      test('sends the token message after connection is established', () async {
        connectionStreamController.onListen = null;
        idTokenStreamController.add('token');
        await Future.microtask(() {});
        final response = subject.connect(path);

        connectionStreamController.add(Connected());
        expect(await response, equals(webSocket));

        await Future.microtask(() {});

        verify(
          () => webSocket.send(jsonEncode(WebSocketMessage.token('token'))),
        ).called(1);

        verify(
          () => webSocketFactory(
            Uri.parse('ws://baseurl.com/path'),
          ),
        ).called(1);
      });

      test('throws ApiClientError on error', () async {
        when(
          () => webSocketFactory(any()),
        ).thenThrow(Exception('oops'));

        await expectLater(
          () => subject.connect(path),
          throwsA(isA<ApiClientError>()),
        );
      });

      test('throws ApiClientError when socket takes too long', () async {
        connectionStreamController.onListen = () {
          Future.delayed(
            const Duration(seconds: 1),
            () => connectionStreamController.add(Connected()),
          );
        };

        expect(
          () => subject.connect(path),
          throwsA(isA<ApiClientError>()),
        );
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
