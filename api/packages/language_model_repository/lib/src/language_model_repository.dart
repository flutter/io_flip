import 'dart:math';

import 'package:db_client/db_client.dart';

/// {@template language_model_repository}
/// Repository providing access language model services
/// {@endtemplate}
class LanguageModelRepository {
  /// {@macro language_model_repository}
  LanguageModelRepository({
    required DbClient dbClient,
    Random? rng,
  }) : _dbClient = dbClient {
    _rng = rng ?? Random();
  }

  late final Random _rng;
  final DbClient _dbClient;

  /// Returns an unique card name.
  Future<String> generateCardName({
    required String characterName,
    required String characterClass,
    required String characterPower,
    required String characterLocation,
  }) async {
    final option = _rng.nextInt(3);
    switch (option) {
      case 0:
        return '$characterClass $characterName';
      case 1:
        return '$characterPower $characterName';
      default:
        return '$characterLocation $characterName';
    }
  }

  /// Returns an unique card flavor text.
  Future<String> generateFlavorText({
    required String character,
    required String characterPower,
    required String characterClass,
    required String location,
  }) async {
    final descriptions = await _dbClient.find('card_descriptions', {
      'character': character,
      'characterClass': characterClass,
      'power': characterPower,
      'location': location,
    });

    if (descriptions.isEmpty) {
      return '';
    }

    final index = _rng.nextInt(descriptions.length);
    return descriptions[index].data['description'] as String;
  }
}
