import 'dart:io';

import 'package:data_loader/data_loader.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

class _MockFile extends Mock implements File {}

void main() {
  group('ImageLoader', () {
    late File csv;
    late File image;
    late String dest;
    late ImageLoader imageLoader;

    setUp(() {
      csv = _MockFile();
      image = _MockFile();
      when(() => image.copy(any())).thenAnswer(
        (_) async => _MockFile(),
      );
      dest = path.join(
        Directory.systemTemp.path,
        'image_loader',
      );
      imageLoader = ImageLoader(
        csv: csv,
        image: image,
        dest: dest,
        variations: 8,
      );
    });

    test('can be instantiated', () {
      expect(
        ImageLoader(
          csv: _MockFile(),
          image: _MockFile(),
          dest: '',
          variations: 8,
        ),
        isNotNull,
      );
    });

    test('load the images', () async {
      when(() => csv.readAsLines()).thenAnswer(
        (_) async => [
          'Character,Class,Power,Location,',
          'Dash,Alien,Banjos,City,',
          'Android,Mage,Bass,Forest,',
        ],
      );

      await imageLoader.loadImages((_, __) {});

      final expectedFilePaths = [
        'dash_alien_city_1.png',
        'dash_alien_forest_2.png',
        'dash_alien_city_1.png',
        'dash_alien_forest_2.png',
        'dash_mage_city_1.png',
        'dash_mage_forest_2.png',
        'dash_mage_city_1.png',
        'dash_mage_forest_2.png',
        'android_alien_city_1.png',
        'android_alien_forest_2.png',
        'android_alien_city_1.png',
        'android_alien_forest_2.png',
        'android_mage_city_1.png',
        'android_mage_forest_2.png',
        'android_mage_city_1.png',
        'android_mage_forest_2.png',
      ];

      for (final filePath in expectedFilePaths) {
        final file = File(
          path.join(
            dest,
            'public',
            'illustrations',
            filePath,
          ),
        );

        expect(file.existsSync(), isTrue);
      }
    });
  });
}
