import 'dart:io';

import 'package:game_domain/game_domain.dart';
import 'package:path/path.dart' as path;

/// {@template data_loader}
/// Dart tool that feed data into the Database
/// {@endtemplate}
class ImageLoader {
  /// {@macro data_loader}
  const ImageLoader({
    required File csv,
    required File image,
    required String dest,
  })  : _csv = csv,
        _image = image,
        _dest = dest;

  final File _csv;

  final File _image;

  final String _dest;

  /// Creates placeholder images for prompts stored in csv file.
  /// [onProgress] is called everytime there is progress,
  /// it takes in the current inserted and the total to insert.
  Future<void> loadImages(void Function(int, int) onProgress) async {
    final lines = await _csv.readAsLines();

    final map = {
      for (final term in PromptTermType.values) term: <String>[],
    };

    for (final line in lines.skip(1)) {
      final parts = line.split(',');

      for (var j = 0; j < 4; j++) {
        final value = parts[j].trim();
        if (value.isNotEmpty) {
          final type = PromptTermType.values[j];
          map[type]!.add(value);
        }
      }
    }

    final fileNames = <String>[];
    var progress = 0;

    for (final character in map[PromptTermType.character]!) {
      for (final characterClass in map[PromptTermType.characterClass]!) {
        for (final power1 in map[PromptTermType.power]!) {
          for (final location in map[PromptTermType.location]!) {
            fileNames.add(
              path
                  .join(
                    _dest,
                    'public',
                    'illustrations',
                    character,
                    characterClass,
                    power1,
                    '$location.png',
                  )
                  .replaceAll(' ', '_')
                  .toLowerCase(),
            );
          }
        }
      }
    }

    final totalFiles = fileNames.length;
    while (fileNames.isNotEmpty) {
      final batch = <String>[];
      while (batch.length < 10 && fileNames.isNotEmpty) {
        batch.add(fileNames.removeLast());
      }

      await Future.wait(
        batch.map((filePath) async {
          await File(filePath).create(recursive: true);
          await _image.copy(filePath).then((_) {
            onProgress(progress, totalFiles);
            progress++;
          });
        }),
      );
    }
  }
}
