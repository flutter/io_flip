// ignore_for_file: prefer_const_constructors
import 'dart:math';

import 'package:db_client/db_client.dart';
import 'package:language_model_repository/language_model_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockDbClient extends Mock implements DbClient {}

class _MockRandom extends Mock implements Random {}

void main() {
  group('LanguageModelRepository', () {
    late DbClient dbClient;
    late Random rng;
    late LanguageModelRepository languageModelRepository;

    setUp(() {
      dbClient = _MockDbClient();
      rng = _MockRandom();
      languageModelRepository = LanguageModelRepository(
        dbClient: dbClient,
        rng: rng,
      );
    });

    test('can be instantiated', () {
      expect(
        LanguageModelRepository(dbClient: _MockDbClient()),
        isNotNull,
      );
    });

    group('generateCardName', () {
      test('generates with class', () async {
        when(() => rng.nextInt(3)).thenReturn(0);
        expect(
          await languageModelRepository.generateCardName(
            characterName: 'Dash',
            characterClass: 'Mage',
            characterPower: 'Baggles',
            characterLocation: 'Beach',
          ),
          equals('Mage Dash'),
        );
      });
      test('generates with power', () async {
        when(() => rng.nextInt(3)).thenReturn(1);
        expect(
          await languageModelRepository.generateCardName(
            characterName: 'Dash',
            characterClass: 'Mage',
            characterPower: 'Baggles',
            characterLocation: 'Beach',
          ),
          equals('Baggles Dash'),
        );
      });
      test('generates with location', () async {
        when(() => rng.nextInt(3)).thenReturn(2);
        expect(
          await languageModelRepository.generateCardName(
            characterName: 'Dash',
            characterClass: 'Mage',
            characterPower: 'Baggles',
            characterLocation: 'Beach',
          ),
          equals('Beach Dash'),
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
