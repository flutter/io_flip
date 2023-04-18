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
      );
    });

    test('can be instantiated', () {
      expect(
        ImageLoader(
          csv: _MockFile(),
          image: _MockFile(),
          dest: '',
        ),
        isNotNull,
      );
    });

    test('load the images', () async {
      when(() => csv.readAsLines()).thenAnswer(
        (_) async => [
          'Character,Class,Power,Power,Location,',
          'Dash,Alien,Banjos,City,',
          'Android,Mage,Bass,Forest,',
        ],
      );

      await imageLoader.loadImages((_, __) {});

      final expectedFilePaths = [
        path.join('dash', 'alien', 'banjos', 'city.png'),
        path.join('dash', 'alien', 'banjos', 'forest.png'),
        path.join('dash', 'alien', 'bass', 'city.png'),
        path.join('dash', 'alien', 'bass', 'forest.png'),
        path.join('dash', 'mage', 'banjos', 'city.png'),
        path.join('dash', 'mage', 'banjos', 'forest.png'),
        path.join('dash', 'mage', 'bass', 'city.png'),
        path.join('dash', 'mage', 'bass', 'forest.png'),
        path.join('android', 'alien', 'banjos', 'city.png'),
        path.join('android', 'alien', 'banjos', 'forest.png'),
        path.join('android', 'alien', 'bass', 'city.png'),
        path.join('android', 'alien', 'bass', 'forest.png'),
        path.join('android', 'mage', 'banjos', 'city.png'),
        path.join('android', 'mage', 'banjos', 'forest.png'),
        path.join('android', 'mage', 'bass', 'city.png'),
        path.join('android', 'mage', 'bass', 'forest.png'),
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

        expect(
          file.existsSync(),
          isTrue,
        );
      }
    });
  });
}
