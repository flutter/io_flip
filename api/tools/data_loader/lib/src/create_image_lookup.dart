// ignore_for_file: avoid_print

import 'dart:io';

import 'package:data_loader/src/prompt_mapper.dart';
import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:path/path.dart' as path;

/// {@template character_folder_validator}
/// Dart tool that checks if the character folder is valid
/// given the prompts stored in csv file.
/// {@endtemplate}
class CreateImageLookup {
  /// {@macro character_folder_validator}
  const CreateImageLookup({
    required DbClient dbClient,
    required File csv,
    required Directory imagesFolder,
    required String character,
    required int variations,
  })  : _dbClient = dbClient,
        _csv = csv,
        _imagesFolder = imagesFolder,
        _character = character,
        _variations = variations;

  final DbClient _dbClient;
  final File _csv;
  final Directory _imagesFolder;
  final String _character;
  final int _variations;

  /// Uses the prompts stored in the csv file to generate
  /// a lookup table in case there are missing images for a given prompt
  /// combination.
  /// [onProgress] is called everytime there is progress,
  /// it takes in the current inserted and the total to insert.
  Future<void> generateLookupTable(
    void Function(int, int) onProgress,
  ) async {
    final lines = await _csv.readAsLines();

    final map = mapCsvToPrompts(lines);

    final tables = <String, List<String>>{};

    final classes = map[PromptTermType.characterClass]!;
    final locations = map[PromptTermType.location]!;

    final total = classes.length * locations.length;

    var progress = 0;
    for (final characterClass in classes) {
      for (final location in locations) {
        // First we check if the combination has all the images.
        final key = [
          _character,
          characterClass,
          location,
        ].join('_').replaceAll(' ', '_').toLowerCase();

        final fileNames = <String>[];

        for (var i = 0; i < _variations; i++) {
          final baseFileName = [
            key,
            '$i.png',
          ].join('_').replaceAll(' ', '_');

          final fileName = path.join(
            _imagesFolder.path,
            baseFileName,
          );

          if (File(fileName).existsSync()) {
            fileNames.add(baseFileName);
          }
        }

        if (fileNames.length != _variations) {
          tables[key] = fileNames;
        }

        progress++;
        onProgress(progress, total);
      }
    }

    for (final entry in tables.entries) {
      print(
        '${entry.key} is missing ${_variations - entry.value.length} images',
      );
      await _dbClient.add(
        'image_lookup_table',
        {
          'prompt': entry.key,
          'available_images': entry.value,
        },
      );
      // So we don't get rate limited.
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
    print('Done');
  }
}
