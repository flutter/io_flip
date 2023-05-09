import 'dart:io';
import 'dart:typed_data';

import 'package:api_client/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockApiClient extends Mock implements ApiClient {}

class _MockResponse extends Mock implements http.Response {}

void main() {
  group('ShareResource', () {
    late ApiClient apiClient;
    late ShareResource resource;
    late http.Response response;
    final bytes = Uint8List(8);

    setUp(() {
      apiClient = _MockApiClient();
      response = _MockResponse();

      when(() => apiClient.shareHandUrl(any())).thenReturn('handUrl');
      when(() => apiClient.shareCardUrl(any())).thenReturn('cardUrl');
      when(
        () => apiClient.getPublic(any(), followRedirect: true),
      ).thenAnswer((_) async => response);
      when(() => response.bodyBytes).thenReturn(bytes);

      resource = ShareResource(
        apiClient: apiClient,
      );
    });

    test('can be instantiated', () {
      expect(
        resource,
        isNotNull,
      );
    });

    test('twitterShareHandUrl returns the correct url', () {
      expect(
        resource.twitterShareHandUrl('id'),
        contains('handUrl'),
      );
    });

    test('twitterShareCardUrl returns the correct url', () {
      expect(
        resource.twitterShareCardUrl('id'),
        contains('cardUrl'),
      );
    });

    test('facebookShareHandUrl returns the correct url', () {
      expect(
        resource.facebookShareHandUrl('id'),
        contains('handUrl'),
      );
    });

    test('facebookShareCardUrl returns the correct url', () {
      expect(
        resource.facebookShareCardUrl('id'),
        contains('cardUrl'),
      );
    });

    group('getShareCardImage', () {
      test('returns a Card', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        final imageResponse = await resource.getShareCardImage('');
        expect(imageResponse, equals(bytes));
      });

      test('throws ApiClientError when request fails', () async {
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Ops');

        await expectLater(
          resource.getShareCardImage('1'),
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'GET public/cards/1 returned status 500 with the following response: "Ops"',
              ),
            ),
          ),
        );
      });
    });

    group('getShareDeckImage', () {
      test('returns a Card', () async {
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        final imageResponse = await resource.getShareDeckImage('');
        expect(imageResponse, equals(bytes));
      });

      test('throws ApiClientError when request fails', () async {
        when(() => response.statusCode)
            .thenReturn(HttpStatus.internalServerError);
        when(() => response.body).thenReturn('Ops');

        await expectLater(
          resource.getShareDeckImage('1'),
          throwsA(
            isA<ApiClientError>().having(
              (e) => e.cause,
              'cause',
              equals(
                'GET public/decks/1 returned status 500 with the following response: "Ops"',
              ),
            ),
          ),
        );
      });
    });
  });
}
