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

    setUp(() {
      dbClient = _MockDbClient();
      promptRepository = PromptRepository(
        dbClient: dbClient,
      );
      when(
        () => dbClient.orderBy(
          'prompt_terms',
          'type',
          limit: 100,
        ),
      ).thenAnswer(
        (_) async => [
          DbEntityRecord(
            id: 'id1',
            data: const {
              'type': 'power',
              'term': 'AAA',
            },
          ),
          DbEntityRecord(
            id: 'id2',
            data: const {
              'type': 'power',
              'term': 'BBB',
            },
          ),
          DbEntityRecord(
            id: 'id3',
            data: const {
              'type': 'characterClass',
              'term': 'CCC',
            },
          ),
          DbEntityRecord(
            id: 'id4',
            data: const {
              'type': 'location',
              'term': 'DDD',
            },
          ),
        ],
      );
    });

    test('can be instantiated', () {
      expect(
        PromptRepository(
          dbClient: dbClient,
        ),
        isNotNull,
      );
    });

    group('getPromptTermsByType', () {
      test('returns a list of terms with location type', () async {
        when(
          () => dbClient.findBy(
            'prompt_terms',
            'type',
            PromptTermType.location.name,
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

        final response = await promptRepository.getPromptTermsByType(
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

    test('getPromptTerms returns a list of terms', () async {
      final response = await promptRepository.getPromptTerms();

      expect(
        response,
        equals(
          [
            PromptTerm(
              id: 'id1',
              type: PromptTermType.power,
              term: 'AAA',
            ),
            PromptTerm(
              id: 'id2',
              type: PromptTermType.power,
              term: 'BBB',
            ),
            PromptTerm(
              id: 'id3',
              type: PromptTermType.characterClass,
              term: 'CCC',
            ),
            PromptTerm(
              id: 'id4',
              type: PromptTermType.location,
              term: 'DDD',
            ),
          ],
        ),
      );
    });

    group('isValidPrompt', () {
      const prompt = Prompt(
        power: 'AAA',
        secondaryPower: 'BBB',
        characterClass: 'CCC',
      );
      setUp(() {
        when(
          () => dbClient.findBy(
            'prompt_terms',
            'term',
            prompt.power,
          ),
        ).thenAnswer(
          (_) async => [
            DbEntityRecord(
              id: 'id1',
              data: const {
                'type': 'power',
                'term': 'AAA',
              },
            ),
          ],
        );
        when(
          () => dbClient.findBy(
            'prompt_terms',
            'term',
            prompt.secondaryPower,
          ),
        ).thenAnswer(
          (_) async => [
            DbEntityRecord(
              id: 'id2',
              data: const {
                'type': 'power',
                'term': 'BBB',
              },
            ),
          ],
        );
        when(
          () => dbClient.findBy(
            'prompt_terms',
            'term',
            prompt.characterClass,
          ),
        ).thenAnswer(
          (_) async => [
            DbEntityRecord(
              id: 'id3',
              data: const {
                'type': 'characterClass',
                'term': 'CCC',
              },
            ),
          ],
        );
      });

      test('isValidPrompt returns true', () async {
        final isValid = await promptRepository.isValidPrompt(prompt);

        expect(isValid, isTrue);
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
