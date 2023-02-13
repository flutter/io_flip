import 'dart:math';

const _names = [
  'The coder',
  'The Designer',
  'The Tester',
  'A bright bird',
  'Free bird',
  'Humming Coder',
  'Bird and code',
  'Dash the Great',
  'Dash the debugger',
  'Dash no code',
  'Double dash',
  'Nameless',
  'Call me bird',
];

final _expressions = [
  'Hey',
  'How are you?',
  'Cool beans',
  'Tally ho!',
  'I love android',
  'Flame is awesome',
  'The new android is great',
  'I want some cheese',
  'Firebase is on fire!',
  'What is real?',
  'Is this reality?',
  'Tuna pizza? Where?',
  'I am running out of creativity',
  'Two slices please',
  'Water please',
  'Keep the change',
  'Table for two',
  'Mars, but also Jupiter',
  'I wish there were two',
  'Nah, I prefer potato chips',
  'Rock!',
  'What about the green hat?',
  'Two dogs and a cat',
  'Ducks!',
  'Where?',
  'I found a lost letter',
  'My garage',
  'The laptop',
  'Super cold',
  'Yes!',
  'No!',
  'Why!',
  'Nice!',
  'In the background!',
  'This is so random',
  'I got nothing',
  'Icecream chocolate cake',
  'Unicorns are real',
];


/// {@template language_model_repository}
/// Repository providing access language model services
/// {@endtemplate}
class LanguageModelRepository {
  /// {@macro language_model_repository}
  const LanguageModelRepository();

  /// Returns an unique card name.
  Future<String> generateCardName() async {
    final rng = Random();
    return _names[rng.nextInt(_names.length)];
  }

  /// Returns an unique card flavor text.
  Future<String> generateFlavorText() async {
    final rng = Random();
    return _expressions[rng.nextInt(_expressions.length)];
  }
}
