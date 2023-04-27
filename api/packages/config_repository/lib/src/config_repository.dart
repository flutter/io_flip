import 'dart:developer';

import 'package:db_client/db_client.dart';

/// {@template config_repository}
/// Repository with access to dynamic project configurations
/// {@endtemplate}
class ConfigRepository {
  /// {@macro config_repository}
  const ConfigRepository({
    required DbClient dbClient,
  }) : _dbClient = dbClient;

  final DbClient _dbClient;

  /// The default number of card variations in the case when none is specified
  /// in the db.
  static int defaultCardVariations = 8;

  /// Return how many variations of the same characters there are per deck.
  Future<int> getCardVariations() async {
    try {
      final result = await _dbClient.findBy('config', 'type', 'variations');
      if (result.isNotEmpty) {
        return int.parse(result.first.data['value'] as String);
      }
    } catch (error, stackStrace) {
      log(
        'Error fetching card variations from db, return the default value',
        error: error,
        stackTrace: stackStrace,
      );
    }

    return defaultCardVariations;
  }
}
