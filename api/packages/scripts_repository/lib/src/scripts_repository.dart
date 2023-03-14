import 'package:db_client/db_client.dart';

/// {@template scripts_repository}
/// Access to the game scripts data source.
/// {@endtemplate}
class ScriptsRepository {
  /// {@macro scripts_repository}
  ScriptsRepository({
    required DbClient dbClient,
  }) : _dbClient = dbClient;

  final DbClient _dbClient;

  /// The default script, used when none is found in the firebase.
  static const defaultLogic = '''
fun compareCards(valueA: int, valueB: int, suitA: str, suitB: str) -> int {
  var evaluation = compareSuits(suitA, suitB);
  if (evaluation == 0) {
    evaluation = compareValues(valueA, valueB);
  }
  return evaluation;
}

fun compareSuits(suitA: str, suitB: str) -> int {
  when (suitA) {
    'fire' -> {
      when (suitB) {
        'air', 'metal' -> return 1;
        'water', 'earth' -> return -1;
        else -> return 0;
      }
    }
    'air' -> {
      when (suitB) {
        'water', 'earth' -> return 1;
        'fire', 'metal' -> return -1;
        else -> return 0;
      }
    }
    'metal' -> {
      when (suitB) {
        'water', 'air' -> return 1;
        'fire', 'earth' -> return -1;
        else -> return 0;
      }
    }
    'earth' -> {
      when (suitB) {
        'fire', 'metal' -> return 1;
        'water', 'air' -> return -1;
        else -> return 0;
      }
    }
    'water' -> {
      when (suitB) {
        'fire', 'earth' -> return 1;
        'metal', 'air' -> return -1;
        else -> return 0;
      }
    }
    else -> return 0;
  }
}

fun compareValues(a: int, b: int) -> int {
  if (a > b) {
    return 1;
  } else if (a < b) {
    return -1;
  } else {
    return 0;
  }
}
''';

  /// Returns the current script rule.
  Future<String> getCurrentScript() async {
    final record = await _findCurrent();

    if (record != null) {
      if (record.data['script'] is String) {
        return record.data['script'] as String;
      }
    }

    return defaultLogic;
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
