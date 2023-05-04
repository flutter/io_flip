import 'dart:math';

import 'package:db_client/db_client.dart';
import 'package:prompt_repository/prompt_repository.dart';

/// {@template language_model_repository}
/// Repository providing access language model services
/// {@endtemplate}
class LanguageModelRepository {
  /// {@macro language_model_repository}
  LanguageModelRepository({
    required DbClient dbClient,
    required PromptRepository promptRepository,
    Random? rng,
  })  : _dbClient = dbClient,
        _promptRepository = promptRepository {
    _rng = rng ?? Random();
  }

  late final Random _rng;
  final PromptRepository _promptRepository;
  final DbClient _dbClient;

  /// Returns an unique card name.
  Future<String> generateCardName({
    required String characterName,
    required String characterClass,
    required String characterPower,
  }) async {
    final option = _rng.nextInt(2);
    switch (option) {
      case 0:
        return '$characterClass $characterName';
      default:
        final shortenedTerm = await _promptRepository.getByTerm(characterPower);
        final cardPower = shortenedTerm?.shortenedTerm ?? characterPower;
        return '$cardPower $characterName';
    }
  }

  String _normalizePrompt(String value) =>
      value.replaceAll(' ', '_').toLowerCase();

  /// Returns an unique card flavor text.
  Future<String> generateFlavorText({
    required String character,
    required String characterPower,
    required String characterClass,
    required String location,
  }) async {
    final descriptions = await _dbClient.find('card_descriptions', {
      'character': _normalizePrompt(character),
      'characterClass': _normalizePrompt(characterClass),
      'power': _normalizePrompt(characterPower),
      'location': _normalizePrompt(location),
    });

    if (descriptions.isEmpty) {
      return '';
    }

    final index = _rng.nextInt(descriptions.length);
    return descriptions[index].data['description'] as String;
  }
}
