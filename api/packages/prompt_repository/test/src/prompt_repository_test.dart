// ignore_for_file: prefer_const_constructors
import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';
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

    group('getPromptTerms', () {
      test('returns a list of terms', () async {
        when(
          () => dbClient.findBy(
            'prompt_terms',
            'type',
            PromptTermType.location,
          ),
        ).thenAnswer(
          (_) async => [
            DbEntityRecord(
              id: 'id1',
              data: const {
                'type': 'location',
                'term': 'AAA',
              },
            ),
            DbEntityRecord(
              id: 'id2',
              data: const {
                'type': 'location',
                'term': 'BBB',
              },
            ),
            DbEntityRecord(
              id: 'id3',
              data: const {
                'type': 'location',
                'term': 'CCC',
              },
            ),
          ],
        );

        final response = await promptRepository.getPromptTerms(
          PromptTermType.location,
        );

        expect(
          response,
          equals(
            [
              PromptTerm(
                id: 'id1',
                type: PromptTermType.location,
                term: 'AAA',
              ),
              PromptTerm(
                id: 'id2',
                type: PromptTermType.location,
                term: 'BBB',
              ),
              PromptTerm(
                id: 'id3',
                type: PromptTermType.location,
                term: 'CCC',
              ),
            ],
          ),
        );
      });
    });

    group('createPromptTerm', () {
      test('adds a new prompt term', () async {
        when(
          () => dbClient.add(
            'prompt_terms',
            {
              'type': 'location',
              'term': 'AAA',
            },
          ),
        ).thenAnswer((_) async => 'id');

        await promptRepository.createPromptTerm(
          PromptTerm(
            type: PromptTermType.location,
            term: 'AAA',
          ),
        );

        verify(
          () => dbClient.add(
            'prompt_terms',
            {
              'type': 'location',
              'term': 'AAA',
            },
          ),
        ).called(1);
      });
    });
  });
}
