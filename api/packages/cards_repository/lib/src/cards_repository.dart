import 'dart:math';

import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:image_model_repository/image_model_repository.dart';
import 'package:language_model_repository/language_model_repository.dart';
import 'package:meta/meta.dart';

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

  /// Then chance of the rare card to be generated.
  @visibleForTesting
  static const rareChance = .2;

  late final Random _rng;

  /// Rolls the chances to generate a rare card.
  bool rollRarity() {
    return _rng.nextDouble() < rareChance;
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
    required DbClient dbClient,
    CardRng? rng,
  })  : _dbClient = dbClient,
        _rng = rng ?? CardRng(),
        _imageModelRepository = imageModelRepository,
        _languageModelRepository = languageModelRepository;

  final DbClient _dbClient;
  final CardRng _rng;
  final ImageModelRepository _imageModelRepository;
  final LanguageModelRepository _languageModelRepository;

  /// Generates a random card.
  Future<Card> generateCard() async {
    final isRare = _rng.rollRarity();
    final modifier = isRare ? _rng.rollAttribute(base: 10) : 0;

    final values = await Future.wait([
      _languageModelRepository.generateCardName(),
      _languageModelRepository.generateFlavorText(),
      _imageModelRepository.generateImage(),
    ]);

    final name = values.first;
    final description = values[1];
    final image = values.last;
    final rarity = isRare;
    final power = _rng.rollAttribute(base: 10, modifier: modifier);
    final suit = Suit.values[_rng.rollAttribute(base: Suit.values.length - 1)];

    final id = await _dbClient.add('cards', {
      'name': name,
      'description': description,
      'image': image,
      'rarity': rarity,
      'power': power,
      'suit': suit.name,
    });

    return Card(
      id: id,
      name: name,
      description: description,
      image: image,
      rarity: isRare,
      power: power,
      suit: suit,
    );
  }

  /// Creates a deck with the given cards.
  Future<String> createDeck({
    required List<String> cardIds,
    required String userId,
  }) {
    return _dbClient.add('decks', {
      'cards': cardIds,
      'userId': userId,
    });
  }

  /// Finds a deck with the given [deckId].
  Future<Deck?> getDeck(String deckId) async {
    final deckData = await _dbClient.getById('decks', deckId);

    if (deckData == null) {
      return null;
    }

    final cardIds = (deckData.data['cards'] as List).cast<String>();

    final cardsData = await Future.wait(
      cardIds.map((id) => _dbClient.getById('cards', id)),
    );

    return Deck.fromJson({
      'id': deckData.id,
      'cards': cardsData
          .whereType<DbEntityRecord>()
          .map(
            (data) => {'id': data.id, ...data.data},
          )
          .toList(),
    });
  }

  /// Finds a card with the given [cardId].
  Future<Card?> getCard(String cardId) async {
    final cardData = await _dbClient.getById('cards', cardId);

    if (cardData == null) {
      return null;
    }

    return Card.fromJson({
      'id': cardData.id,
      ...cardData.data,
    });
  }
}
