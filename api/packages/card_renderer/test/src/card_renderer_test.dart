// ignore_for_file: prefer_const_constructors, one_member_abstracts
import 'dart:typed_data';

import 'package:card_renderer/card_renderer.dart';
import 'package:game_domain/game_domain.dart';
import 'package:http/http.dart';
import 'package:image/image.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockCommand extends Mock implements Command {}

class _MockBitmapFont extends Mock implements BitmapFont {}

class _MockResponse extends Mock implements Response {}

abstract class __HttpClient {
  Future<Response> get(Uri uri);
}

class _MockHttpClient extends Mock implements __HttpClient {}

abstract class __BitmapFontLoader {
  BitmapFont load(Uint8List bytes);
}

class _MockBitmapFontLoader extends Mock implements __BitmapFontLoader {}

void main() {
  group('CardRenderer', () {
    late __HttpClient httpClient;
    late __BitmapFontLoader bitmapFontLoader;

    late CardRenderer cardRenderer;

    setUpAll(() {
      registerFallbackValue(Uint8List(0));
      registerFallbackValue(Uri.parse(''));
      registerFallbackValue(_MockBitmapFont());
    });

    test('can be instantiated', () {
      expect(CardRenderer(), isNotNull);
    });

    group('renderCard', () {
      late Command illustrationCommand;
      late Command frameCommand;
      late Command compositionCommand;

      const card = Card(
        id: '',
        name: 'Card Description',
        description: '',
        image: 'http://image.com/bla.png',
        power: 0,
        suit: Suit.fire,
        rarity: false,
      );
      const rareCard = Card(
        id: '',
        name: 'Card Description',
        description: '',
        image: 'http://image.com/bla.png',
        power: 0,
        suit: Suit.fire,
        rarity: true,
      );

      setUp(() {
        illustrationCommand = _MockCommand();
        frameCommand = _MockCommand();
        compositionCommand = _MockCommand();

        when(compositionCommand.execute)
            .thenAnswer((_) async => compositionCommand);
        when(() => compositionCommand.outputBytes).thenReturn(Uint8List(0));

        httpClient = _MockHttpClient();
        when(() => httpClient.get(any())).thenAnswer((_) async {
          final response = _MockResponse();
          when(() => response.statusCode).thenReturn(200);
          when(() => response.bodyBytes).thenReturn(Uint8List(0));
          return response;
        });

        bitmapFontLoader = _MockBitmapFontLoader();
        when(() => bitmapFontLoader.load(any())).thenReturn(_MockBitmapFont());

        var commandCounter = 0;
        cardRenderer = CardRenderer(
          getCall: httpClient.get,
          parseFont: bitmapFontLoader.load,
          createCommand: () {
            switch (commandCounter++) {
              case 0:
                return illustrationCommand;
              case 1:
                return frameCommand;
              case 2:
                return compositionCommand;
              default:
                throw Exception('Unexpected command creation');
            }
          },
        );
      });

      test('returns the image bytes', () async {
        final bytes = await cardRenderer.renderCard(card);

        expect(bytes, isNotNull);
      });

      test('loads the correct images', () async {
        await cardRenderer.renderCard(card);

        verify(() => httpClient.get(Uri.parse(card.image))).called(1);
        verify(
          () => httpClient.get(
            Uri.parse('http://127.0.0.1:8080/assets/card-fire.png'),
          ),
        ).called(1);
        verify(
          () => httpClient.get(
            Uri.parse(
              'http://127.0.0.1:8080/assets/GoogleSans-Regular.ttf.zip',
            ),
          ),
        ).called(1);
      });

      test('decode images correctly', () async {
        await cardRenderer.renderCard(card);

        verify(() => illustrationCommand.decodePng(any())).called(1);
        verify(() => frameCommand.decodePng(any())).called(1);
      });

      test('draw the correct texts in the image', () async {
        await cardRenderer.renderCard(card);

        verify(
          () => compositionCommand.drawString(
            card.power.toString(),
            font: any(named: 'font'),
            x: any(named: 'x'),
            y: any(named: 'y'),
            color: any(named: 'color'),
          ),
        ).called(1);

        verify(
          () => compositionCommand.drawString(
            card.name,
            font: any(named: 'font'),
            x: any(named: 'x'),
            y: any(named: 'y'),
            color: any(named: 'color'),
          ),
        ).called(1);
      });

      test('applies correct filters when card is rare', () async {
        await cardRenderer.renderCard(rareCard);

        verify(() => compositionCommand.filter(rainbowFilter)).called(1);
        verify(() => compositionCommand.chromaticAberration(shift: 2))
            .called(1);
      });

      test('throws CardRendererFailure when the output is null', () async {
        when(() => compositionCommand.outputBytes).thenReturn(null);

        await expectLater(
          () => cardRenderer.renderCard(card),
          throwsA(
            isA<CardRendererFailure>().having(
              (e) => e.toString(),
              'message',
              '[CardRendererFailure]: Failed to render card',
            ),
          ),
        );
      });

      test('throws CardRendererFailure when the request fails', () async {
        when(
          () => httpClient.get(
            Uri.parse('http://127.0.0.1:8080/assets/card-fire.png'),
          ),
        ).thenAnswer((_) async {
          final response = _MockResponse();
          when(() => response.statusCode).thenReturn(500);
          return response;
        });

        await expectLater(
          () => cardRenderer.renderCard(card),
          throwsA(
            isA<CardRendererFailure>().having(
              (e) => e.message,
              'message',
              'Exception: Failed to get image from http://127.0.0.1:8080/assets/card-fire.png',
            ),
          ),
        );
      });
    });

    group('renderDeck', () {
      late Command compositionCommand;

      final cards = List.generate(
        3,
        (i) => Card(
          id: 'card$i',
          name: 'Card Description',
          description: '',
          image: 'http://image.com/bla.png',
          power: 0,
          suit: Suit.fire,
          rarity: false,
        ),
      );

      setUp(() {
        compositionCommand = _MockCommand();

        when(compositionCommand.execute)
            .thenAnswer((_) async => compositionCommand);
        when(() => compositionCommand.outputBytes).thenReturn(Uint8List(0));

        httpClient = _MockHttpClient();
        when(() => httpClient.get(any())).thenAnswer((_) async {
          final response = _MockResponse();
          when(() => response.statusCode).thenReturn(200);
          when(() => response.bodyBytes).thenReturn(Uint8List(0));
          return response;
        });

        bitmapFontLoader = _MockBitmapFontLoader();
        when(() => bitmapFontLoader.load(any())).thenReturn(_MockBitmapFont());

        var commandCounter = 0;
        cardRenderer = CardRenderer(
          getCall: httpClient.get,
          parseFont: bitmapFontLoader.load,
          createCommand: () {
            if (commandCounter++ == 12) {
              return compositionCommand;
            } else {
              final command = _MockCommand();
              when(command.execute).thenAnswer((_) async => command);
              when(() => command.outputBytes).thenReturn(Uint8List(0));
              return command;
            }
          },
        );
      });

      test('returns the image bytes', () async {
        final bytes = await cardRenderer.renderDeck(cards);

        expect(bytes, isNotNull);
      });

      test('throws CardRendererFailure when the output is null', () async {
        when(() => compositionCommand.outputBytes).thenReturn(null);

        await expectLater(
          () => cardRenderer.renderDeck(cards),
          throwsA(
            isA<CardRendererFailure>().having(
              (e) => e.toString(),
              'message',
              '[CardRendererFailure]: Failed to render deck',
            ),
          ),
        );
      });

      test('throws CardRendererFailure when something else fails', () async {
        when(compositionCommand.execute).thenThrow(Exception('Ops'));

        await expectLater(
          () => cardRenderer.renderDeck(cards),
          throwsA(
            isA<CardRendererFailure>().having(
              (e) => e.message,
              'message',
              'Exception: Ops',
            ),
          ),
        );
      });
    });
  });
}
