import 'dart:io';

import 'package:csv/csv.dart';
import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';

/// {@template data_loader}
/// Dart tool that feed descriptions into the Descriptions base
/// {@endtemplate}
class DescriptionsLoader {
  /// {@macro data_loader}
  const DescriptionsLoader({
    required DbClient dbClient,
    required File csv,
  })  : _dbClient = dbClient,
        _csv = csv;

  final File _csv;
  final DbClient _dbClient;

  String _normalizeTerm(String term) {
    return term.trim().toLowerCase().replaceAll(' ', '_');
  }

  /// Loads the descriptions from the CSV file into the database
  /// [onProgress] is called everytime there is progress,
  /// it takes in the current inserted and the total to insert.
  Future<void> loadDescriptions(void Function(int, int) onProgress) async {
    final descriptions = <CardDescription>[];

    final content = await _csv.readAsString();

    final lines = const CsvToListConverter().convert(content);
    for (final parts in lines.skip(1)) {
      final character = _normalizeTerm(parts.first as String);
      final characterClass = _normalizeTerm(parts[1] as String);
      final power = _normalizeTerm(parts[2] as String);
      final location = _normalizeTerm(parts[3] as String);

      for (var i = 4; i < parts.length; i++) {
        final value = parts[i] as String;
        if (value.trim().isEmpty) {
          continue;
        }
        descriptions.add(
          CardDescription(
            character: character,
            characterClass: characterClass,
            power: power,
            location: location,
            description: value,
          ),
        );
      }
    }

    var progress = 0;
    onProgress(progress, descriptions.length);

    for (final description in descriptions) {
      progress++;

      await _dbClient.add(
        'card_descriptions',
        description.toJson(),
      );
      // So we don't get rate limited
      await Future<void>.delayed(const Duration(milliseconds: 10));

      onProgress(progress, descriptions.length);
    }
  }
}
