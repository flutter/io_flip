import 'dart:typed_data';

import 'package:card_renderer/card_renderer.dart';
import 'package:game_domain/game_domain.dart';
import 'package:http/http.dart';
import 'package:image/image.dart';

const _width = 654;
const _height = 870;

/// {@template card_renderer_failure}
/// Exception thrown when a card rendering fails.
/// {@endtemplate}
class CardRendererFailure implements Exception {
  /// {@macro card_renderer_failure}
  CardRendererFailure(this.message, this.stackTrace);

  /// Message describing the failure.
  final String message;

  /// Stack trace of the failure.
  final StackTrace stackTrace;

  @override
  String toString() => '[CardRendererFailure]: $message';
}

/// Function definition to get an image from a [Uri] used by
/// [CardRenderer].
typedef GetCall = Future<Response> Function(Uri uri);

/// Function definition to create a [Command] used by [CardRenderer].
typedef CreateCommand = Command Function();

/// Function definition to parse a [BitmapFont] from a [Uint8List] used by
/// [CardRenderer].
typedef ParseFont = BitmapFont Function(Uint8List);

/// {@template card_renderer}
/// Renders a card based on its metadata and illustration
/// {@endtemplate}
class CardRenderer {
  /// {@macro card_renderer}
  CardRenderer({
    String airSuitAsset = 'http://127.0.0.1:8080/assets/card-air.png',
    String earthSuitAsset = 'http://127.0.0.1:8080/assets/card-ground.png',
    String fireSuitAsset = 'http://127.0.0.1:8080/assets/card-fire.png',
    String waterSuitAsset = 'http://127.0.0.1:8080/assets/card-water.png',
    String metalSuitAsset = 'http://127.0.0.1:8080/assets/card-metal.png',
    String fontAsset =
        'http://127.0.0.1:8080/assets/GoogleSans-Regular.ttf.zip',
    CreateCommand createCommand = Command.new,
    ParseFont parseFont = BitmapFont.fromZip,
    GetCall getCall = get,
  })  : _suitFrames = {
          Suit.air: airSuitAsset,
          Suit.earth: earthSuitAsset,
          Suit.fire: fireSuitAsset,
          Suit.water: waterSuitAsset,
          Suit.metal: metalSuitAsset,
        },
        _fontAsset = fontAsset,
        _createCommand = createCommand,
        _parseFont = parseFont,
        _get = getCall;

  final Map<Suit, String> _suitFrames;
  final String _fontAsset;

  final GetCall _get;

  final CreateCommand _createCommand;

  final ParseFont _parseFont;

  Future<Uint8List> _getImage(Uri uri) async {
    final response = await _get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to get image from $uri');
    }

    return response.bodyBytes;
  }

  /// Renders a [Card] to a [Uint8List] containing the PNG image.
  Future<Uint8List> renderCard(Card card) async {
    try {
      final assets = await Future.wait([
        _getImage(Uri.parse(card.image)),
        _getImage(Uri.parse(_suitFrames[card.suit]!)),
        _getImage(Uri.parse(_fontAsset)),
      ]);

      final illustrationCmd = _createCommand()..decodePng(assets.first);
      final frameCmd = _createCommand()..decodePng(assets[1]);

      final fontPower = _parseFont(assets.last)..size = 60;
      final fontDescription = _parseFont(assets.last);

      final compositionCommand = _createCommand()
        ..createImage(width: _width, height: _height, numChannels: 4)
        ..compositeImage(
          illustrationCmd,
          dstX: 0,
          dstY: 0,
          dstW: _width,
          dstH: _height,
        )
        ..compositeImage(frameCmd)
        ..drawString(
          card.name,
          font: fontDescription,
          x: 50,
          y: 810,
          color: ColorRgb8(0, 0, 0),
        )
        ..drawString(
          card.power.toString(),
          font: fontPower,
          x: 600,
          y: 20,
          color: ColorRgb8(0, 0, 0),
        );
      if (card.rarity) {
        compositionCommand
          ..filter(rainbowFilter)
          ..chromaticAberration(shift: 2);
      }
      compositionCommand.encodePng();

      await compositionCommand.execute();

      final output = compositionCommand.outputBytes;
      if (output == null) {
        throw CardRendererFailure('Failed to render card', StackTrace.current);
      }

      return output;
    } on CardRendererFailure {
      rethrow;
    } catch (e, s) {
      throw CardRendererFailure(e.toString(), s);
    }
  }

  /// Renders a list of [Card] to a [Uint8List] containing the PNG image.
  Future<Uint8List> renderDeck(List<Card> cards) async {
    try {
      final cardBytes = await Future.wait(
        cards.map(renderCard),
      );

      final cardCommands = cardBytes
          .map(
            (e) => _createCommand()..decodePng(e),
          )
          .toList();

      const angleValue = 10;
      const offsetModifier = 12;

      final compositionCommand = _createCommand()
        ..createImage(
          width: _width * cards.length,
          height: _height + offsetModifier * angleValue,
          numChannels: 4,
        );

      const angles = {
        0: -angleValue,
        1: 0,
        2: angleValue,
      };

      const offsets = {
        0: [50, 0],
        1: [0, 0],
        2: [-170, 0],
      };

      for (var i = 0; i < cards.length; i++) {
        compositionCommand.compositeImage(
          cardCommands[i]..copyRotate(angle: angles[i]!),
          dstX: (_width * i) + offsets[i]![0],
          dstY: offsets[i]![1],
          dstW: _width + offsetModifier * angles[i]!.abs(),
          dstH: _height + offsetModifier * angles[i]!.abs(),
        );
      }

      compositionCommand.encodePng();

      await compositionCommand.execute();

      final output = compositionCommand.outputBytes;
      if (output == null) {
        throw CardRendererFailure('Failed to render deck', StackTrace.current);
      }

      return output;
    } on CardRendererFailure {
      rethrow;
    } catch (e, s) {
      throw CardRendererFailure(e.toString(), s);
    }
  }
}
