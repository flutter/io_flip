// ignore_for_file: avoid_print

import 'dart:io';

import 'package:data_loader/src/prompt_mapper.dart';
import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';

/// {@template check_missing_image_tables}
/// Dart tool that checks if there are any missing tables.
/// {@endtemplate}
class MissingImageTables {
  /// {@macro check_missing_image_tables}
  const MissingImageTables({
    required DbClient dbClient,
    required File csv,
    required String character,
  })  : _dbClient = dbClient,
        _csv = csv,
        _character = character;

  final File _csv;
  final DbClient _dbClient;
  final String _character;

  String _normalizeTerm(String term) {
    return term.trim().toLowerCase().replaceAll(' ', '_');
  }

  /// Checks if the database have all the image tables.
  /// [onProgress] is called everytime there is progress,
  /// it takes in the current inserted and the total to insert.
  Future<void> checkMissing(void Function(int, int) onProgress) async {
    final lines = await _csv.readAsLines();

    final map = mapCsvToPrompts(lines);
    final queries = <String>[];

    for (final characterClass in map[PromptTermType.characterClass]!) {
      for (final location in map[PromptTermType.location]!) {
        queries.add(
          '${_normalizeTerm(_character)}_${_normalizeTerm(characterClass)}'
          '_${_normalizeTerm(location)}',
        );
      }
    }

    for (final query in queries) {
      final result = await _dbClient.findBy(
        'image_lookup_table',
        'prompt',
        query,
      );

      if (result.isEmpty) {
        print(query);
      }
    }
    print('Done');
  }
}
