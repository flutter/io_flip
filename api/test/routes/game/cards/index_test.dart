import 'dart:io';

import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prompt_repository/prompt_repository.dart';
import 'package:test/test.dart';

import '../../../../routes/game/cards/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockCardsRepository extends Mock implements CardsRepository {}

class _MockPromptRepository extends Mock implements PromptRepository {}

class _MockRequest extends Mock implements Request {}

void main() {
  group('POST /game/cards', () {
    late CardsRepository cardsRepository;
    late PromptRepository promptRepository;
    late Request request;
    late RequestContext context;

    final cards = List.generate(
      12,
      (_) => const Card(
        id: '',
        name: '',
        description: '',
        rarity: true,
        image: '',
        power: 1,
        suit: Suit.air,
      ),
    );
    const prompt = Prompt(
      power: 'baggles',
      characterClass: 'mage',
    );
    setUp(() {
      promptRepository = _MockPromptRepository();
      cardsRepository = _MockCardsRepository();
      when(
        () => cardsRepository.generateCards(
          characterClass: any(named: 'characterClass'),
          characterPower: any(
            named: 'characterPower',
          ),
        ),
      ).thenAnswer(
        (_) async => cards,
      );

      request = _MockRequest();
      when(() => request.method).thenReturn(HttpMethod.post);

      context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.request).thenReturn(request);
      when(request.json).thenAnswer((_) async => prompt.toJson());

      when(() => context.read<CardsRepository>()).thenReturn(cardsRepository);
      when(() => context.read<PromptRepository>()).thenReturn(promptRepository);
      registerFallbackValue(prompt);
      when(() => promptRepository.isValidPrompt(any()))
          .thenAnswer((invocation) => Future.value(true));
    });

    test('responds with a 200', () async {
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
    });

    test('uses the character class and power from the prompt', () async {
      await route.onRequest(context);
      verify(
        () => cardsRepository.generateCards(
          characterClass: 'mage',
          characterPower: 'baggles',
        ),
      ).called(1);
    });

    test('responds bad request when class is null', () async {
      when(request.json).thenAnswer(
        (_) async => const Prompt(power: '').toJson(),
      );
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.badRequest));
    });

    test('responds bad request when power is null', () async {
      when(request.json).thenAnswer(
        (_) async => const Prompt(
          characterClass: '',
        ).toJson(),
      );
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.badRequest));
    });

    test('responds with the generated card', () async {
      final response = await route.onRequest(context);

      final json = await response.json();
      expect(
        json,
        equals({
          'cards': List.generate(
            12,
            (index) => {
              'id': '',
              'name': '',
              'description': '',
              'rarity': true,
              'image': '',
              'power': 1,
              'suit': 'air',
              'shareImage': null,
            },
          ),
        }),
      );
    });

    test('allows only post methods', () async {
      when(() => request.method).thenReturn(HttpMethod.get);
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('invalid prompt returns Bad Request', () async {
      when(() => promptRepository.isValidPrompt(any()))
          .thenAnswer((invocation) => Future.value(false));
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.badRequest));
    });
  });
}
