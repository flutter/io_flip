import 'dart:io';

import 'package:api/game_url.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/public/share.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockCardRepository extends Mock implements CardsRepository {}

class _MockLogger extends Mock implements Logger {}

void main() {
  group('GET /public/share', () {
    late Request request;
    late RequestContext context;
    late CardsRepository cardsRepository;
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

      context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<Logger>()).thenReturn(logger);
      when(() => context.read<GameUrl>()).thenReturn(gameUrl);
      when(() => context.read<CardsRepository>()).thenReturn(cardsRepository);
    });

    test('responds with a 200', () async {
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
    });

    test('responds with a 404 when the card is not found', () async {
      when(() => cardsRepository.getCard(card.id)).thenAnswer(
        (_) async => null,
      );
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.notFound));
    });

    test('responds with a 404 when no cardId is in the request', () async {
      when(() => request.uri).thenReturn(
        Uri.parse('/public/share'),
      );
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.notFound));
    });
  });
}
