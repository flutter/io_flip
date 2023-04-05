import 'dart:io';
import 'dart:typed_data';

import 'package:api/game_url.dart';
import 'package:card_renderer/card_renderer.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:firebase_cloud_storage/firebase_cloud_storage.dart';
import 'package:game_domain/game_domain.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../routes/public/cards/[cardId].dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockCardRepository extends Mock implements CardsRepository {}

class _MockCardRenderer extends Mock implements CardRenderer {}

class _MockFirebaseCloudStorage extends Mock implements FirebaseCloudStorage {}

class _MockLogger extends Mock implements Logger {}

void main() {
  group('GET /public/cards/[cardId]', () {
    late Request request;
    late RequestContext context;
    late CardsRepository cardsRepository;
    late CardRenderer cardRenderer;
    late FirebaseCloudStorage firebaseCloudStorage;
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

    setUpAll(() {
      registerFallbackValue(Uint8List(0));
      registerFallbackValue(card);
    });

    setUp(() {
      request = _MockRequest();
      when(() => request.method).thenReturn(HttpMethod.get);
      when(() => request.uri).thenReturn(
        Uri.parse('/public/cards/${card.id}'),
      );

      logger = _MockLogger();

      cardsRepository = _MockCardRepository();
      when(() => cardsRepository.getCard(card.id)).thenAnswer(
        (_) async => card,
      );

      when(() => cardsRepository.updateCard(any())).thenAnswer(
        (_) async {},
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

      firebaseCloudStorage = _MockFirebaseCloudStorage();
      when(() => firebaseCloudStorage.uploadFile(any(), any()))
          .thenAnswer((_) async => 'https://example.com/share.png');
      when(() => context.read<FirebaseCloudStorage>())
          .thenReturn(firebaseCloudStorage);
    });

    test('responds with a 200', () async {
      final response = await route.onRequest(context, card.id);
      expect(response.statusCode, equals(HttpStatus.ok));
    });

    test('updates the card with the share image', () async {
      await route.onRequest(context, card.id);

      verify(
        () => cardsRepository.updateCard(
          card.copyWithShareImage('https://example.com/share.png'),
        ),
      ).called(1);
    });

    test('redirects with the cached image if present', () async {
      when(() => cardsRepository.getCard(card.id)).thenAnswer(
        (_) async => card.copyWithShareImage('https://example.com/share.png'),
      );
      final response = await route.onRequest(context, card.id);

      expect(
        response.statusCode,
        equals(HttpStatus.movedPermanently),
      );
      expect(
        response.headers['location'],
        equals('https://example.com/share.png'),
      );
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
