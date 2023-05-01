import 'dart:io';

import 'package:data_loader/src/prompt_mapper.dart';
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
    required int variations,
  })  : _csv = csv,
        _image = image,
        _dest = dest,
        _variations = variations;

  final File _csv;

  final File _image;

  final String _dest;

  final int _variations;

  /// Creates placeholder images for prompts stored in csv file.
  /// [onProgress] is called everytime there is progress,
  /// it takes in the current inserted and the total to insert.
  Future<void> loadImages(void Function(int, int) onProgress) async {
    final lines = await _csv.readAsLines();

    final map = mapCsvToPrompts(lines);

    final fileNames = <String>[];
    var progress = 0;

    for (final character in map[PromptTermType.character]!) {
      for (final characterClass in map[PromptTermType.characterClass]!) {
        for (final location in map[PromptTermType.location]!) {
          for (var i = 0; i < _variations; i++) {
            fileNames.add(
              path
                  .join(
                    _dest,
                    'public',
                    'illustrations',
                    [
                      character,
                      characterClass,
                      location,
                      '$i.png',
                    ].join('_').replaceAll(' ', '_'),
                  )
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
