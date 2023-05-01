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

  /// The default waiting time limit for private matches.
  static int defaultPrivateTimeLimit = 120;

  Future<String?> _getValue(String type) async {
    final result = await _dbClient.findBy('config', 'type', type);
    if (result.isNotEmpty) {
      return result.first.data['value'] as String;
    }
    return null;
  }

  /// Return how many variations of the same characters there are per deck.
  Future<int> getCardVariations() async {
    try {
      final value = await _getValue('variations');
      if (value != null) {
        return int.parse(value);
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

  /// Return how many variations of the same characters there are per deck.
  Future<int> getPrivateMatchTimeLimit() async {
    try {
      final value = await _getValue('private_match_time_limit');
      if (value != null) {
        return int.parse(value);
      }
    } catch (error, stackStrace) {
      log(
        'Error fetching private match time limit from db, return the default '
        'value',
        error: error,
        stackTrace: stackStrace,
      );
    }

    return defaultPrivateTimeLimit;
  }
}
