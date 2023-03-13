import 'package:hetu_script/hetu/hetu.dart';

/// {@template game_script_machine}
/// Holds and proccess the scripts responsible for calculating the result of a
/// game match.
/// {@endtemplate}
class GameScriptMachine {
  /// {@macro game_script_machine}
  GameScriptMachine._();

  /// Initializes and return a new machine instance.
  factory GameScriptMachine.initialize(String script) {
    return GameScriptMachine._()..currentScript = script;
  }

  late Hetu _hetu;

  late String _currentScript;

  /// Updates the current script in this machine.
  set currentScript(String value) {
    _currentScript = value;
    _hetu = Hetu()
      ..init()
      ..eval(_currentScript);
  }

  /// Returns the running script of the machine.
  String get currentScript => _currentScript;

  /// Evaluates the the power of card [a] agains the value of card [b].
  /// Returns 1 if bigger, -1 if smaller, 0 is equals.
  int evalCardPower(int a, int b) {
    final value = _hetu.invoke('compareCards', positionalArgs: [a, b]) as int;
    return value;
  }
}
