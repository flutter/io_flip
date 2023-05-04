// ignore_for_file: prefer_const_constructors
import 'dart:math';

import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:language_model_repository/language_model_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prompt_repository/prompt_repository.dart';
import 'package:test/test.dart';

class _MockDbClient extends Mock implements DbClient {}

class _MockPromptRepository extends Mock implements PromptRepository {}

class _MockRandom extends Mock implements Random {}

void main() {
  group('LanguageModelRepository', () {
    late DbClient dbClient;
    late PromptRepository promptRepository;
    late Random rng;
    late LanguageModelRepository languageModelRepository;

    setUp(() {
      dbClient = _MockDbClient();
      promptRepository = _MockPromptRepository();

      when(() => promptRepository.getByTerm('Baggles')).thenAnswer(
        (_) async => PromptTerm(
          id: '1',
          term: 'Baggles',
          shortenedTerm: 'Baggles',
          type: PromptTermType.power,
        ),
      );

      rng = _MockRandom();
      languageModelRepository = LanguageModelRepository(
        dbClient: dbClient,
        promptRepository: promptRepository,
        rng: rng,
      );
    });

    test('can be instantiated', () {
      expect(
        LanguageModelRepository(
          dbClient: _MockDbClient(),
          promptRepository: _MockPromptRepository(),
        ),
        isNotNull,
      );
    });

    group('generateCardName', () {
      test('generates with class', () async {
        when(() => rng.nextInt(2)).thenReturn(0);
        expect(
          await languageModelRepository.generateCardName(
            characterName: 'Dash',
            characterClass: 'Mage',
            characterPower: 'Baggles',
          ),
          equals('Mage Dash'),
        );
      });
      test('generates with power', () async {
        when(() => rng.nextInt(2)).thenReturn(1);
        expect(
          await languageModelRepository.generateCardName(
            characterName: 'Dash',
            characterClass: 'Mage',
            characterPower: 'Baggles',
          ),
          equals('Baggles Dash'),
        );
      });
      test('generates with the shorter power when there is one', () async {
        when(() => promptRepository.getByTerm('Breaking Dance')).thenAnswer(
          (_) async => PromptTerm(
            id: '1',
            term: 'Breaking Dance',
            shortenedTerm: 'Break Dance',
            type: PromptTermType.power,
          ),
        );
        when(() => rng.nextInt(2)).thenReturn(1);
        expect(
          await languageModelRepository.generateCardName(
            characterName: 'Dash',
            characterClass: 'Mage',
            characterPower: 'Breaking Dance',
          ),
          equals('Break Dance Dash'),
        );
      });

      test("uses the informed power when there isn't a shorter one", () async {
        when(() => promptRepository.getByTerm('Breaking Dance')).thenAnswer(
          (_) async => null,
        );
        when(() => rng.nextInt(2)).thenReturn(1);
        expect(
          await languageModelRepository.generateCardName(
            characterName: 'Dash',
            characterClass: 'Mage',
            characterPower: 'Breaking Dance',
          ),
          equals('Breaking Dance Dash'),
        );
      });
    });

    group('generateFlavorText', () {
      test('returns a random value of the query', () async {
        when(() => rng.nextInt(2)).thenReturn(1);
        when(
          () => dbClient.find('card_descriptions', {
            'character': 'dash',
            'characterClass': 'wizard',
            'power': 'baggles',
            'location': 'beach',
          }),
        ).thenAnswer(
          (_) async => [
            DbEntityRecord(id: '', data: const {'description': 'A'}),
            DbEntityRecord(id: '', data: const {'description': 'B'}),
          ],
        );
        expect(
          await languageModelRepository.generateFlavorText(
            character: 'Dash',
            characterClass: 'Wizard',
            characterPower: 'Baggles',
            location: 'Beach',
          ),
          equals('B'),
        );
      });

      test('makes the correct query', () async {
        when(() => rng.nextInt(2)).thenReturn(1);
        when(
          () => dbClient.find('card_descriptions', {
            'character': 'super_dash',
            'characterClass': 'ice_wizard',
            'power': 'super_baggles',
            'location': 'active_volcano',
          }),
        ).thenAnswer(
          (_) async => [
            DbEntityRecord(id: '', data: const {'description': 'A'}),
            DbEntityRecord(id: '', data: const {'description': 'B'}),
          ],
        );
        expect(
          await languageModelRepository.generateFlavorText(
            character: 'Super Dash',
            characterClass: 'Ice Wizard',
            characterPower: 'Super Baggles',
            location: 'Active Volcano',
          ),
          equals('B'),
        );
      });

      test('returns empty is nothing is found', () async {
        when(() => rng.nextInt(2)).thenReturn(1);
        when(
          () => dbClient.find('card_descriptions', {
            'character': 'dash',
            'characterClass': 'wizard',
            'power': 'baggles',
            'location': 'beach',
          }),
        ).thenAnswer(
          (_) async => [],
        );
        expect(
          await languageModelRepository.generateFlavorText(
            character: 'Dash',
            characterPower: 'Baggles',
            characterClass: 'Wizard',
            location: 'Beach',
          ),
          isEmpty,
        );
      });
    });
  });
}
