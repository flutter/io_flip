import 'dart:io';

import 'package:data_loader/src/prompt_mapper.dart';
import 'package:game_domain/game_domain.dart';
import 'package:path/path.dart' as path;

/// {@template character_folder_validator}
/// Dart tool that checks if the character folder is valid
/// given the prompts stored in csv file.
/// {@endtemplate}
class CharacterFolderValidator {
  /// {@macro character_folder_validator}
  const CharacterFolderValidator({
    required File csv,
    required Directory imagesFolder,
    required String character,
    required int variations,
  })  : _csv = csv,
        _imagesFolder = imagesFolder,
        _character = character,
        _variations = variations;

  final File _csv;
  final Directory _imagesFolder;
  final String _character;
  final int _variations;

  /// Loads the data from the CSV file into the database
  /// [onProgress] is called everytime there is progress,
  /// it takes in the current inserted and the total to insert.
  Future<List<String>> validate(void Function(int, int) onProgress) async {
    final lines = await _csv.readAsLines();

    final map = mapCsvToPrompts(lines);

    final fileNames = <String>[];
    final missingFiles = <String>[];

    for (final characterClass in map[PromptTermType.characterClass]!) {
      for (final location in map[PromptTermType.location]!) {
        for (var i = 0; i < _variations; i++) {
          fileNames.add(
            path
                .join(
                  _imagesFolder.path,
                  [
                    _character,
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
    var progress = 0;
    onProgress(progress, fileNames.length);

    for (final filename in fileNames) {
      progress++;

      if (!File(filename).existsSync()) {
        missingFiles.add(filename);
      }

      onProgress(progress, fileNames.length);
    }

    return missingFiles;
  }
}
