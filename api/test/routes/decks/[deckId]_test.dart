import 'dart:io';

import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/decks/[deckId].dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockCardsRepository extends Mock implements CardsRepository {}

class _MockRequest extends Mock implements Request {}

class _MockLogger extends Mock implements Logger {}

void main() {
  group('GET /decks/[deckId]', () {
    late CardsRepository cardsRepository;
    late Request request;
    late RequestContext context;
    late Logger logger;

    const deck = Deck(
      userId: 'userId',
      id: 'deckId',
      userId: 'userId',
      cards: [
        Card(
          id: '',
          name: '',
          description: '',
          image: '',
          power: 10,
          rarity: false,
          suit: Suit.air,
        ),
      ],
    );

    setUp(() {
      cardsRepository = _MockCardsRepository();
      when(() => cardsRepository.getDeck(any())).thenAnswer((_) async => deck);

      request = _MockRequest();
      when(() => request.method).thenReturn(HttpMethod.get);
      when(request.json).thenAnswer(
        (_) async => deck.toJson(),
      );

      logger = _MockLogger();

      context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<CardsRepository>()).thenReturn(cardsRepository);
      when(() => context.read<Logger>()).thenReturn(logger);
    });

    test('responds with a 200', () async {
      final response = await route.onRequest(context, deck.id);
      expect(response.statusCode, equals(HttpStatus.ok));
    });

    test('responds with the deck', () async {
      final response = await route.onRequest(context, deck.id);

      final json = await response.json() as Map<String, dynamic>;
      expect(
        json,
        equals(deck.toJson()),
      );
    });

    test("responds 404 when the deck doesn't exists", () async {
      when(() => cardsRepository.getDeck(any())).thenAnswer((_) async => null);
      final response = await route.onRequest(context, deck.id);

      expect(response.statusCode, equals(HttpStatus.notFound));
    });

    test('allows only get methods', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      final response = await route.onRequest(context, deck.id);
      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });
  });
}
