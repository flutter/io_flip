// ignore_for_file: prefer_const_constructors
import 'package:db_client/db_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prompt_repository/prompt_repository.dart';
import 'package:test/test.dart';

class _MockDbClient extends Mock implements DbClient {}

void main() {
  group('PromptRepository', () {
    late DbClient dbClient;
    late PromptRepository promptRepository;

    const whitelistDocumentId = 'id';

    setUp(() {
      dbClient = _MockDbClient();
      promptRepository = PromptRepository(
        dbClient: dbClient,
        whitelistDocumentId: whitelistDocumentId,
      );
    });

    test('can be instantiated', () {
      expect(
        PromptRepository(
          dbClient: dbClient,
          whitelistDocumentId: whitelistDocumentId,
        ),
        isNotNull,
      );
    });

    group('getPromptWhitelist', () {
      const whitelist = ['AAA', 'BBB', 'CCC'];

      test('returns the whitelist', () async {
        when(() => dbClient.getById('prompt_whitelist', whitelistDocumentId))
            .thenAnswer(
          (_) async => DbEntityRecord(
            id: whitelistDocumentId,
            data: const {
              'whitelist': ['AAA', 'BBB', 'CCC'],
            },
          ),
        );
        final response = await promptRepository.getPromptWhitelist();
        expect(response, equals(whitelist));
      });

      test('returns empty list if not found', () async {
        when(() => dbClient.getById('prompt_whitelist', any())).thenAnswer(
          (_) async => null,
        );
        final response = await promptRepository.getPromptWhitelist();
        expect(response, isEmpty);
      });
    });
  });
}
