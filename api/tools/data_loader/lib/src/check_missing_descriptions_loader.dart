// ignore_for_file: avoid_print

import 'dart:io';

import 'package:data_loader/src/prompt_mapper.dart';
import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';

/// {@template check_missing_descriptions}
/// Dart tool that feed descriptions into the Descriptions base
/// {@endtemplate}
class MissingDescriptions {
  /// {@macro check_missing_descriptions}
  const MissingDescriptions({
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

  /// Loads the descriptions from the CSV file into the database
  /// [onProgress] is called everytime there is progress,
  /// it takes in the current inserted and the total to insert.
  Future<void> checkMissing(void Function(int, int) onProgress) async {
    const skipLocation = [
      'grassy_field',
    ];

    final lines = await _csv.readAsLines();

    final map = mapCsvToPrompts(lines);
    final queries = <Map<String, dynamic>>[];

    for (final characterClass in map[PromptTermType.characterClass]!) {
      for (final power in map[PromptTermType.power]!) {
        for (final location in map[PromptTermType.location]!) {
          if (skipLocation.contains(_normalizeTerm(location))) {
            continue;
          }
          queries.add(
            {
              'character': _normalizeTerm(_character),
              'characterClass': _normalizeTerm(characterClass),
              'power': _normalizeTerm(power),
              'location': _normalizeTerm(location),
            },
          );
        }
      }
    }

    for (final query in queries) {
      final result = await _dbClient.find(
        'card_descriptions',
        query,
      );

      if (result.isEmpty) {
        print(query.values.join('_'));
      }
    }
  }
}
