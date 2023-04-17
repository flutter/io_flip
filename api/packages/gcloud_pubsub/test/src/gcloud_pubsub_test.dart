// ignore_for_file: prefer_const_constructors, one_member_abstracts
import 'dart:typed_data';

import 'package:gcloud_pubsub/gcloud_pubsub.dart';
import 'package:grpc/grpc.dart' hide Response;
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockHttpBasedAuthenticator extends Mock
    implements HttpBasedAuthenticator {
  @override
  Future<void> authenticate(Map<String, String> metadata, String uri) async {
    metadata['mock_header'] = 'mock_value';
  }
}

class _MockResponse extends Mock implements Response {}

abstract class __HttpClient {
  Future<Response> post(Uri uri, {Map<String, String>? headers, dynamic body});
}

class _MockHttpClient extends Mock implements __HttpClient {}

void main() {
  group('GcloudPubsub', () {
    late GcloudPubsub gCloudPubSub;
    late HttpBasedAuthenticator authenticator;
    late Response response;
    late __HttpClient httpClient;

    setUpAll(() {
      registerFallbackValue(Uri());
    });

    setUp(() {
      authenticator = _MockHttpBasedAuthenticator();
      response = _MockResponse();
      when(() => response.statusCode).thenReturn(200);

      httpClient = _MockHttpClient();
      when(
        () => httpClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any<dynamic>(named: 'body'),
        ),
      ).thenAnswer((_) async => response);

      gCloudPubSub = GcloudPubsub(
        authenticatorBuilder: (_) async => authenticator,
        postCall: httpClient.post,
      );
    });

    test('can be instantiated', () {
      expect(
        GcloudPubsub(),
        isNotNull,
      );
    });

    test(
      'throws GcloudPubsubFailure when the request fails',
      () async {
        when(() => response.statusCode).thenReturn(500);
        when(() => response.body).thenReturn('Error');

        await expectLater(
          () => gCloudPubSub.pushCardToQueue(),
          throwsA(
            isA<GcloudPubsubFailure>().having(
              (e) => e.toString(),
              'message',
              equals('Error'),
            ),
          ),
        );
      },
    );
  });
}
