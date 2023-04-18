import 'dart:math';

import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:image_model_repository/image_model_repository.dart';
import 'package:language_model_repository/language_model_repository.dart';

/// {@template cards_repository}
/// Access to Cards Datasource.
/// {@endtemplate}
class CardsRepository {
  /// {@macro cards_repository}
  CardsRepository({
    required ImageModelRepository imageModelRepository,
    required LanguageModelRepository languageModelRepository,
    required DbClient dbClient,
    required GameScriptMachine gameScriptMachine,
    Random? rng,
  })  : _dbClient = dbClient,
        _imageModelRepository = imageModelRepository,
        _languageModelRepository = languageModelRepository,
        _gameScriptMachine = gameScriptMachine,
        _rng = rng ?? Random();

  final DbClient _dbClient;
  final Random _rng;
  final GameScriptMachine _gameScriptMachine;
  final ImageModelRepository _imageModelRepository;
  final LanguageModelRepository _languageModelRepository;

  /// Generates a random card.
  Future<Card> generateCard() async {
    final isRare = _gameScriptMachine.rollCardRarity();

    final values = await Future.wait([
      _languageModelRepository.generateCardName(),
      _languageModelRepository.generateFlavorText(),
      _imageModelRepository.generateImage(),
    ]);

    final name = values.first;
    final description = values[1];
    final image = values.last;
    final rarity = isRare;
    final power = _gameScriptMachine.rollCardPower(isRare: isRare);
    final suit = Suit.values[_rng.nextInt(Suit.values.length)];

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
      'userId': deckData.data['userId'],
      'shareImage': deckData.data['shareImage'],
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

  /// Updates the given [card] in the database.
  Future<void> updateCard(Card card) async {
    final data = card.toJson()..remove('id');

    await _dbClient.update(
      'cards',
      DbEntityRecord(
        id: card.id,
        data: data,
      ),
    );
  }

  /// Updates the given [deck] in the database.
  Future<void> updateDeck(Deck deck) async {
    final data = deck.toJson()..remove('id');

    data['cards'] = (data['cards'] as List<Map<String, dynamic>>)
        .map((card) => card['id'])
        .toList();

    await _dbClient.update(
      'decks',
      DbEntityRecord(
        id: deck.id,
        data: data,
      ),
    );
  }
}
