/// {@template scripts_repository}
/// Access to the game scripts data source.
/// {@endtemplate}
class ScriptsRepository {
  /// {@macro scripts_repository}
  ScriptsRepository();

  // TODO(erickzanardo): keeping in memory for now, but moving this
  // to firebase later.
  final Map<String, String> _scripts = {
    '1': '''
fun compareCards(a, b) -> int {
  if (a > b) {
    return 1;
  } else if (a < b) {
    return -1;
  } else {
    return 0;
  }
}
''',
  };

  String _current = '1';

  /// Returns the current script rule.
  Future<String> getCurrentScript() async {
    return _scripts[_current]!;
  }

  /// Updates the current rule set to the given [key].
  Future<void> setCurrent(String key) async {
    _current = key;
  }

  /// Returns get script of the given [key].
  Future<String> getScript(String key) async {
    return _scripts[key]!;
  }

  /// Updates the script of the given [key] to the given
  /// [content].
  Future<void> updateScript(String key, String content) async {
    _scripts[key] = content;
  }

  /// Updates the current script to the given [content].
  Future<void> updateCurrentScript(String content) async {
    _scripts[_current] = content;
  }
}
