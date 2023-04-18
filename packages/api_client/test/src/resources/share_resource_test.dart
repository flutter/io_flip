import 'package:api_client/api_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  group('ShareResource', () {
    late ApiClient apiClient;
    late ShareResource resource;

    setUp(() {
      apiClient = _MockApiClient();

      when(() => apiClient.shareHandUrl(any())).thenReturn('handUrl');
      when(() => apiClient.shareCardUrl(any())).thenReturn('cardUrl');
      when(() => apiClient.shareGameUrl()).thenReturn('gameUrl');

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

    test('shareGameUrl', () {
      expect(
        resource.shareGameUrl(),
        equals('gameUrl'),
      );
    });
  });
}
