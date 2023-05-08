import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

/// {@template config_repository}
/// Repository for remote configs.
/// {@endtemplate}
class ConfigRepository {
  /// {@macro config_repository}
  ConfigRepository({
    required this.db,
  }) {
    configCollection = db.collection('config');
  }

  /// The wait time for private matches.
  final int defaultPrivateTimeLimit = 120;

  /// The wait time for a match before a CPU joins.
  final int defaultMatchWaitTimeLimit = 3;

  /// The wait time for a match before a CPU joins.
  final double defaultCPUAutoMatchPercentage = .9;

  /// The [FirebaseFirestore] instance.
  final FirebaseFirestore db;

  /// The [CollectionReference] for the config.
  late final CollectionReference<Map<String, dynamic>> configCollection;

  /// Return the private match wait time limit.
  Future<int> getPrivateMatchTimeLimit() async {
    try {
      final results = await configCollection
          .where('type', isEqualTo: 'private_match_time_limit')
          .get();

      final data = results.docs.first.data();
      return data['value'] as int;
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

  /// Return the match wait time limit before CPU joins.
  Future<int> getMatchWaitTimeLimit() async {
    try {
      final results = await configCollection
          .where('type', isEqualTo: 'match_wait_time_limit')
          .get();

      final data = results.docs.first.data();
      return data['value'] as int;
    } catch (error, stackStrace) {
      log(
        'Error match time limit from db, return the default '
        'value',
        error: error,
        stackTrace: stackStrace,
      );
    }

    return defaultMatchWaitTimeLimit;
  }

  /// Return the match wait time limit before CPU joins.
  Future<double> getCPUAutoMatchPercentage() async {
    try {
      final results = await configCollection
          .where('type', isEqualTo: 'cpu_auto_match_percentage')
          .get();

      final data = results.docs.first.data();
      return (data['value'] as double).clamp(0.0, 1.0);
    } catch (error, stackStrace) {
      log(
        'Error match time limit from db, return the default '
        'value',
        error: error,
        stackTrace: stackStrace,
      );
    }

    return defaultCPUAutoMatchPercentage;
  }
}
