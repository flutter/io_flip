// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:data_loader/data_loader.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

class _MockFile extends Mock implements File {}

class _MockDirectory extends Mock implements Directory {}

void main() {
  group('CharacterFolderValidator', () {
    setUpAll(() {
      registerFallbackValue(
        PromptTerm(term: '', type: PromptTermType.character),
      );
    });

    test('can be instantiated', () {
      expect(
        CharacterFolderValidator(
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

      setUp(() {
        csv = _MockFile();

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
            'Character,Class,Power,Location,',
            'Dash,Alien,Banjos,City,',
            'Android,Mage,Bass,Forest,',
          ],
        );

        final validator = CharacterFolderValidator(
          csv: csv,
          imagesFolder: imagesFolder,
          character: 'dash',
          variations: 2,
        );

        final missingFiles = await validator.validate((_, __) {});
        expect(
          missingFiles.map(path.basename).toList(),
          equals(
            [
              'dash_alien_forest_1.png',
              'dash_mage_city_0.png',
            ],
          ),
        );
      });

      test('progress is called correctly', () async {
        when(() => csv.readAsLines()).thenAnswer(
          (_) async => [
            'Character,Class,Power,Location,',
            'Dash,Alien,Banjos,City,',
          ],
        );
        final validator = CharacterFolderValidator(
          csv: csv,
          imagesFolder: imagesFolder,
          character: 'dash',
          variations: 2,
        );

        final progress = <List<int>>[];
        await validator.validate((current, total) {
          progress.add([current, total]);
        });

        expect(
          progress,
          equals(
            [
              [0, 2],
              [1, 2],
              [2, 2],
            ],
          ),
        );
      });
    });
  });
}
