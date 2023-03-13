import 'dart:io';

import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/decks/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockCardsRepository extends Mock implements CardsRepository {}

class _MockRequest extends Mock implements Request {}

class _MockLogger extends Mock implements Logger {}

void main() {
  group('POST /', () {
    late CardsRepository cardsRepository;
    late Request request;
    late RequestContext context;
    late Logger logger;

    setUp(() {
      cardsRepository = _MockCardsRepository();
      when(
        () => cardsRepository.createDeck(
          cardIds: any(named: 'cardIds'),
          userId: any(named: 'userId'),
        ),
      ).thenAnswer((_) async => 'deckId');

      request = _MockRequest();
      when(() => request.method).thenReturn(HttpMethod.post);
      when(request.json).thenAnswer(
        (_) async => {
          'cards': ['a', 'b', 'c'],
          'userId': 'mock-userId',
        },
      );

      logger = _MockLogger();

      context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<CardsRepository>()).thenReturn(cardsRepository);
      when(() => context.read<Logger>()).thenReturn(logger);
    });

    test('responds with a 200', () async {
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
    });

    test('responds with a 400 when request is invalid', () async {
      when(request.json).thenAnswer((_) async => {'cards': 'a'});
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.badRequest));
    });

    test('responds with the deck id', () async {
      final response = await route.onRequest(context);

      final json = await response.json() as Map<String, dynamic>;
      expect(
        json['id'],
        equals('deckId'),
      );
    });

    test('allows only post methods', () async {
      when(() => request.method).thenReturn(HttpMethod.get);
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });
  });
}
