import 'dart:math';

import 'package:cards_repository/cards_repository.dart';
import 'package:image_model_repository/image_model_repository.dart';
import 'package:language_model_repository/language_model_repository.dart';


/// {@template card_rng}
/// Generate random attributes to be used in the card generation.
/// {@endtemplate}
class CardRng {

  /// {@macro card_rng}
  CardRng({
    Random? rng,
  }) {
    _rng = rng ?? Random();
  }

  static const _rareChance = .2;

  late final Random _rng;

  /// Rolls the chances to generate a rare card.
  bool rollRarity() {
    return _rng.nextDouble() < _rareChance;
  }

  /// Rolls the value for an attribute.
  int rollAttribute({
    required int base,
    int modifier = 0,
  }) {
    return (_rng.nextDouble() * base + modifier).round();
  }
}

/// {@template cards_repository}
/// Access to Cards Datasource.
/// {@endtemplate}
class CardsRepository {

  /// {@macro cards_repository}
  CardsRepository({
    required ImageModelRepository imageModelRepository,
    required LanguageModelRepository languageModelRepository,
    CardRng? rng,
  }) {
    _rng = rng ?? CardRng();
    _imageModelRepository = imageModelRepository;
    _languageModelRepository = languageModelRepository;
  }

  late final CardRng _rng;
  late final ImageModelRepository _imageModelRepository;
  late final LanguageModelRepository _languageModelRepository;

  /// Generates a random card.
  Future<Card> generateCard() async {
    final isRare = _rng.rollRarity();
    final modifier = isRare ? _rng.rollAttribute(base: 10) : 0;

    final values = await Future.wait([
      _languageModelRepository.generateCardName(),
      _languageModelRepository.generateFlavorText(),
      _imageModelRepository.generateImage(),
    ]);

    return Card(
      id: '',
      name: values.first,
      description: values[1],
      image: values.last,
      rarity: isRare,
      product: _rng.rollAttribute(base: 10, modifier: modifier),
      design: _rng.rollAttribute(base: 10, modifier: modifier),
      frontend: _rng.rollAttribute(base: 10, modifier: modifier),
      backend: _rng.rollAttribute(base: 10, modifier: modifier),
    );
  }
}
