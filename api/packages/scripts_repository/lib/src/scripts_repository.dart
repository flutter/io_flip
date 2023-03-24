import 'package:db_client/db_client.dart';
import 'package:game_script_machine/game_script_machine.dart';

/// {@template scripts_repository}
/// Access to the game scripts data source.
/// {@endtemplate}
class ScriptsRepository {
  /// {@macro scripts_repository}
  ScriptsRepository({
    required DbClient dbClient,
  }) : _dbClient = dbClient;

  final DbClient _dbClient;

  /// Returns the current script rule.
  Future<String> getCurrentScript() async {
    final record = await _findCurrent();

    if (record != null) {
      if (record.data['script'] is String) {
        return record.data['script'] as String;
      }
    }

    return defaultGameLogic;
  }

  Future<DbEntityRecord?> _findCurrent() async {
    final results = await _dbClient.findBy(
      'scripts',
      'selected',
      true,
    );

    if (results.isNotEmpty) {
      return results.first;
    }

    return null;
  }

  /// Updates the current script to the given [content].
  Future<void> updateCurrentScript(String content) async {
    final currentRecord = await _findCurrent();

    if (currentRecord != null) {
      await _dbClient.update(
        'scripts',
        DbEntityRecord(
          id: currentRecord.id,
          data: {
            ...currentRecord.data,
            'script': content,
          },
        ),
      );
    } else {
      await _dbClient.add(
        'scripts',
        {
          'script': content,
          'selected': true,
        },
      );
    }
  }
}
