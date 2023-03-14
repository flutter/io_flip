import 'dart:io';

import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/cards/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockCardsRepository extends Mock implements CardsRepository {}

class _MockRequest extends Mock implements Request {}

void main() {
  group('POST /', () {
    late CardsRepository cardsRepository;
    late Request request;
    late RequestContext context;

    const card = Card(
      id: '',
      name: '',
      description: '',
      rarity: true,
      image: '',
      power: 1,
      suit: Suit.air,
    );
    setUp(() {
      cardsRepository = _MockCardsRepository();
      when(cardsRepository.generateCard).thenAnswer((_) async => card);

      request = _MockRequest();
      when(() => request.method).thenReturn(HttpMethod.post);

      context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<CardsRepository>()).thenReturn(cardsRepository);
    });

    test('responds with a 200', () async {
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
    });

    test('responds with the generated card', () async {
      final response = await route.onRequest(context);

      final json = await response.json();
      expect(
        json,
        equals({
          'id': '',
          'name': '',
          'description': '',
          'rarity': true,
          'image': '',
          'power': 1,
        }),
      );
    });

    test('allows only post methods', () async {
      when(() => request.method).thenReturn(HttpMethod.get);
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });
  });
}
