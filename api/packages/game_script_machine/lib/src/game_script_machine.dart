import 'package:game_domain/game_domain.dart';
import 'package:hetu_script/hetu_script.dart';

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

  /// Evaluates the two cards against each other.
  /// Returns 1 if bigger, -1 if smaller, 0 is equals.
  int compare(Card a, Card b) {
    final value = _hetu.invoke(
      'compareCards',
      positionalArgs: [a.power, b.power, a.suit.name, b.suit.name],
    ) as int;
    return value;
  }

  /// Evaluates the two suits against each other.
  /// Returns 1 if `a` is bigger, -1 if `a` is smaller, 0 if both are equal.
  int compareSuits(Suit a, Suit b) {
    final value = _hetu.invoke(
      'compareSuits',
      positionalArgs: [a.name, b.name],
    ) as int;
    return value;
  }
}
