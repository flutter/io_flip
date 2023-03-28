import 'dart:io';
import 'dart:typed_data';

import 'package:api/game_url.dart';
import 'package:card_renderer/card_renderer.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../routes/public/cards/[cardId].dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockCardRepository extends Mock implements CardsRepository {}

class _MockCardRenderer extends Mock implements CardRenderer {}

class _MockLogger extends Mock implements Logger {}

void main() {
  group('GET /public/cards/[cardId]', () {
    late Request request;
    late RequestContext context;
    late CardsRepository cardsRepository;
    late CardRenderer cardRenderer;
    late Logger logger;
    const gameUrl = GameUrl('https://example.com');

    const card = Card(
      id: 'cardId',
      name: 'cardName',
      description: 'cardDescription',
      image: 'cardImageUrl',
      suit: Suit.fire,
      rarity: false,
      power: 10,
    );

    setUp(() {
      request = _MockRequest();
      when(() => request.method).thenReturn(HttpMethod.get);
      when(() => request.uri).thenReturn(
        Uri.parse('/public/share?cardId=${card.id}'),
      );

      logger = _MockLogger();

      cardsRepository = _MockCardRepository();
      when(() => cardsRepository.getCard(card.id)).thenAnswer(
        (_) async => card,
      );

      cardRenderer = _MockCardRenderer();
      when(() => cardRenderer.renderCard(card)).thenAnswer(
        (_) async => Uint8List(0),
      );

      context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<Logger>()).thenReturn(logger);
      when(() => context.read<GameUrl>()).thenReturn(gameUrl);
      when(() => context.read<CardsRepository>()).thenReturn(cardsRepository);
      when(() => context.read<CardRenderer>()).thenReturn(cardRenderer);
    });

    test('responds with a 200', () async {
      final response = await route.onRequest(context, card.id);
      expect(response.statusCode, equals(HttpStatus.ok));
    });

    test('responds with a 404 if the card is not found', () async {
      when(() => cardsRepository.getCard(card.id)).thenAnswer(
        (_) async => null,
      );
      final response = await route.onRequest(context, card.id);
      expect(response.statusCode, equals(HttpStatus.notFound));
    });

    test('only allows get methods', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      final response = await route.onRequest(context, card.id);
      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });
  });
}
