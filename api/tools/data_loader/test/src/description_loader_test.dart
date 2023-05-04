// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:data_loader/data_loader.dart';
import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockDbClient extends Mock implements DbClient {}

class _MockFile extends Mock implements File {}

void main() {
  group('DescriptionsLoader', () {
    late DescriptionsLoader dataLoader;
    late DbClient dbClient;
    late File csv;

    setUpAll(() {
      registerFallbackValue(
        PromptTerm(term: '', type: PromptTermType.character),
      );
    });

    setUp(() {
      dbClient = _MockDbClient();
      when(() => dbClient.add(any(), any())).thenAnswer(
        (_) async => '',
      );
      csv = _MockFile();
      dataLoader = DescriptionsLoader(
        dbClient: dbClient,
        csv: csv,
      );
    });

    test('can be instantiated', () {
      expect(
        DescriptionsLoader(
          dbClient: _MockDbClient(),
          csv: _MockFile(),
        ),
        isNotNull,
      );
    });

    group('loadDescriptions', () {
      test('load descriptions correctly', () async {
        when(() => csv.readAsString()).thenAnswer(
          (_) async => ListToCsvConverter().convert([
            [
              'Character',
              'Class',
              'Power',
              'Power(Shorter)',
              'Location',
              'Desc 1',
              'Desc 2'
            ],
            ['Dash', 'Alien', 'Banjos', 'B', 'City', 'Desc 1', 'Desc 2'],
            ['Sparky', 'Alien', 'Banjos', 'B', 'City', 'Desc 1', 'Desc 2'],
          ]),
        );

        await dataLoader.loadDescriptions((_, __) {});

        verify(
          () => dbClient.add(
            'card_descriptions',
            {
              'character': 'dash',
              'characterClass': 'alien',
              'power': 'banjos',
              'powerShortened': 'b',
              'location': 'city',
              'description': 'Desc 1',
            },
          ),
        ).called(1);
        verify(
          () => dbClient.add(
            'card_descriptions',
            {
              'character': 'dash',
              'characterClass': 'alien',
              'power': 'banjos',
              'powerShortened': 'b',
              'location': 'city',
              'description': 'Desc 2',
            },
          ),
        ).called(1);
        verify(
          () => dbClient.add(
            'card_descriptions',
            {
              'character': 'sparky',
              'characterClass': 'alien',
              'power': 'banjos',
              'powerShortened': 'b',
              'location': 'city',
              'description': 'Desc 1',
            },
          ),
        ).called(1);
        verify(
          () => dbClient.add(
            'card_descriptions',
            {
              'character': 'sparky',
              'characterClass': 'alien',
              'power': 'banjos',
              'powerShortened': 'b',
              'location': 'city',
              'description': 'Desc 2',
            },
          ),
        ).called(1);
      });

      test('progress is called correctly', () async {
        when(() => csv.readAsString()).thenAnswer(
          (_) async => ListToCsvConverter().convert([
            [
              'Character',
              'Class',
              'Power',
              'Power(Shortened)',
              'Location',
              'Desc 1',
              'Desc 2'
            ],
            ['Dash', 'Alien', 'Banjos', 'B', 'City', 'Desc 1', 'Desc 2'],
            ['Sparky', 'Alien', 'Banjos', 'B', 'City', 'Desc 1', 'Desc 2'],
          ]),
        );

        final progress = <List<int>>[];
        await dataLoader.loadDescriptions((current, total) {
          progress.add([current, total]);
        });

        expect(
          progress,
          equals(
            [
              [0, 6],
              [1, 6],
              [2, 6],
              [3, 6],
              [4, 6],
              [5, 6],
              [6, 6],
            ],
          ),
        );
      });
    });
  });
}
