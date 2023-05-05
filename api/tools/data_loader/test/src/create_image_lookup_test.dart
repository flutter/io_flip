// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:data_loader/data_loader.dart';
import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

class _MockFile extends Mock implements File {}

class _MockDirectory extends Mock implements Directory {}

class _MockDbClient extends Mock implements DbClient {}

void main() {
  group('CreateImageLookup', () {
    setUpAll(() {
      registerFallbackValue(
        PromptTerm(term: '', type: PromptTermType.character),
      );
    });

    test('can be instantiated', () {
      expect(
        CreateImageLookup(
          dbClient: _MockDbClient(),
          csv: _MockFile(),
          imagesFolder: _MockDirectory(),
          character: 'dash',
          variations: 3,
        ),
        isNotNull,
      );
    });

    group('validate', () {
      late File csv;
      late Directory imagesFolder;
      late DbClient dbClient;

      setUp(() {
        csv = _MockFile();
        dbClient = _MockDbClient();
        when(
          () => dbClient.add(
            any(),
            any(),
          ),
        ).thenAnswer((_) async => '');

        imagesFolder = Directory(
          path.join(
            Directory.systemTemp.path,
            'character_folder_validator_test',
          ),
        );

        if (imagesFolder.existsSync()) {
          imagesFolder.deleteSync(recursive: true);
        }
        imagesFolder.createSync();

        final files = [
          File(path.join(imagesFolder.path, 'dash_alien_city_0.png')),
          File(path.join(imagesFolder.path, 'dash_alien_city_1.png')),
          File(path.join(imagesFolder.path, 'dash_mage_city_1.png')),
          File(path.join(imagesFolder.path, 'dash_alien_forest_0.png')),
          File(path.join(imagesFolder.path, 'dash_mage_forest_0.png')),
          File(path.join(imagesFolder.path, 'dash_mage_forest_1.png')),
        ];

        for (final file in files) {
          file.createSync();
        }
      });

      test('return the missing files', () async {
        when(() => csv.readAsLines()).thenAnswer(
          (_) async => [
            'Character,Class,Power,Power(Shorter),Location,',
            'Dash,Alien,Banjos,B,City,',
            'Android,Mage,Bass,B,Forest,',
          ],
        );

        final generator = CreateImageLookup(
          dbClient: dbClient,
          csv: csv,
          imagesFolder: imagesFolder,
          character: 'dash',
          variations: 2,
        );

        await generator.generateLookupTable((_, __) {});

        verify(
          () => dbClient.add('image_lookup_table', {
            'prompt': 'dash_alien_forest',
            'available_images': ['dash_alien_forest_0.png'],
          }),
        ).called(1);
        verify(
          () => dbClient.add('image_lookup_table', {
            'prompt': 'dash_mage_city',
            'available_images': ['dash_mage_city_1.png'],
          }),
        ).called(1);
      });

      test('progress is called correctly', () async {
        when(() => csv.readAsLines()).thenAnswer(
          (_) async => [
            'Character,Class,Power,Power(Shorter),Location,',
            'Dash,Alien,Banjos,B,City,',
            'Android,Mage,Bass,B,Forest,',
          ],
        );
        final generator = CreateImageLookup(
          dbClient: dbClient,
          csv: csv,
          imagesFolder: imagesFolder,
          character: 'dash',
          variations: 2,
        );

        final progress = <List<int>>[];
        await generator.generateLookupTable((current, total) {
          progress.add([current, total]);
        });

        expect(
          progress,
          equals(
            [
              [1, 4],
              [2, 4],
              [3, 4],
              [4, 4],
            ],
          ),
        );
      });
    });
  });
}
