// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math' as math;

import 'package:path/path.dart' as path;

/// {@template character_folder_validator}
/// Dart tool that checks if the character folder is valid
/// given the prompts stored in csv file.
/// {@endtemplate}
class NormalizeImageNames {
  /// {@macro character_folder_validator}
  const NormalizeImageNames({
    required Directory imagesFolder,
    required Directory destImagesFolder,
  })  : _imagesFolder = imagesFolder,
        _destImagesFolder = destImagesFolder;

  final Directory _imagesFolder;
  final Directory _destImagesFolder;

  /// Uses the prompts stored in the csv file to generate
  /// a lookup table in case there are missing images for a given prompt
  /// combination.
  /// [onProgress] is called everytime there is progress,
  /// it takes in the current inserted and the total to insert.
  Future<void> normalize(
    void Function(int, int) onProgress,
  ) async {
    final map = <String, List<String>>{};

    await _imagesFolder
        .list(recursive: true)
        .where((entity) => entity is File)
        .forEach((entity) {
      final file = entity as File;

      final basename = path.basename(file.path);

      final promptKey =
          RegExp('([a-z_]+[^_0-9])').allMatches(basename).first.group(0)!;

      map.putIfAbsent(promptKey, () => []).add(file.path);
    });

    var biggerVariation = 0;

    var progress = 0;
    onProgress(0, map.length);
    for (final entry in map.entries) {
      print('${entry.key} has ${entry.value.length} variations');
      biggerVariation = math.max(biggerVariation, entry.value.length);

      for (var i = 0; i < entry.value.length; i++) {
        final filePath = entry.value[i];
        if (!filePath.endsWith('png')) continue;

        print('Processing $filePath');

        final destFile = filePath
            .replaceAll(_imagesFolder.path, _destImagesFolder.path)
            .replaceAll(path.basename(filePath), '${entry.key}_$i.png');

        File(filePath).copySync(destFile);
      }
      onProgress(++progress, map.length);
    }

    print('Done normalizing images');
    print('Bigger variation: $biggerVariation');
  }
}
