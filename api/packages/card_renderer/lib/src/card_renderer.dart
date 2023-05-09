import 'dart:typed_data';

import 'package:card_renderer/card_renderer.dart';
import 'package:game_domain/game_domain.dart';
import 'package:http/http.dart';
import 'package:image/image.dart';

// Component Sizes
const _cardSize = _Size(width: 327, height: 435);
const _characterSize = _Size(width: 279, height: 279);
const _descriptionSize = _Size(width: 263, height: 72);
const _powerSpriteSize = _Size(width: 113, height: 64);

// Component Positions
const _titlePosition = 300;
const _characterPosition = [24, 20];
const _powerSpritePosition = [218, 44];
const _descriptionPosition = [32, 345];
const _elementIconPositions = {
  Suit.air: [213, 12],
  Suit.earth: [210, 4],
  Suit.fire: [225, 2],
  Suit.water: [226, 3],
  Suit.metal: [220, 24],
};

// Assets
const _powerSpriteAsset = 'http://127.0.0.1:8080/assets/power-sprites.png';
const _titleFontAsset = 'http://127.0.0.1:8080/assets/Saira-Bold-28.ttf.zip';
const _descriptionFontAsset =
    'http://127.0.0.1:8080/assets/GoogleSans-14.ttf.zip';
const _elementIconAssets = {
  Suit.air: 'http://127.0.0.1:8080/assets/icon-air.png',
  Suit.earth: 'http://127.0.0.1:8080/assets/icon-earth.png',
  Suit.fire: 'http://127.0.0.1:8080/assets/icon-fire.png',
  Suit.water: 'http://127.0.0.1:8080/assets/icon-water.png',
  Suit.metal: 'http://127.0.0.1:8080/assets/icon-metal.png',
};
const _elementFrameAssets = {
  Suit.air: 'http://127.0.0.1:8080/assets/card-air.png',
  Suit.earth: 'http://127.0.0.1:8080/assets/card-earth.png',
  Suit.fire: 'http://127.0.0.1:8080/assets/card-fire.png',
  Suit.water: 'http://127.0.0.1:8080/assets/card-water.png',
  Suit.metal: 'http://127.0.0.1:8080/assets/card-metal.png',
};
const _holoFrameAssets = {
  Suit.air: 'http://127.0.0.1:8080/assets/holos/card-air.png',
  Suit.earth: 'http://127.0.0.1:8080/assets/holos/card-earth.png',
  Suit.fire: 'http://127.0.0.1:8080/assets/holos/card-fire.png',
  Suit.water: 'http://127.0.0.1:8080/assets/holos/card-water.png',
  Suit.metal: 'http://127.0.0.1:8080/assets/holos/card-metal.png',
};

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
/// Renders a card based on its metadata and character
/// {@endtemplate}
class CardRenderer {
  /// {@macro card_renderer}
  CardRenderer({
    // Card Frames

    CreateCommand createCommand = Command.new,
    ParseFont parseFont = BitmapFont.fromZip,
    GetCall getCall = get,
  })  : _createCommand = createCommand,
        _parseFont = parseFont,
        _get = getCall;

  final GetCall _get;
  final CreateCommand _createCommand;
  final ParseFont _parseFont;

  Future<Uint8List> _getFile(Uri uri) async {
    final response = await _get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to get image from $uri');
    }

    return response.bodyBytes;
  }

  List<_Line> _splitText(String string, BitmapFont font, int width) {
    final words = string.split(RegExp(r'\s+'));
    final lines = <_Line>[];

    var lineWidth = 0;
    var line = '';
    for (var w in words) {
      final ws = StringBuffer()
        ..write(w)
        ..write(' ');
      w = ws.toString();
      final chars = w.codeUnits;
      var wordWidth = 0;
      for (final c in chars) {
        if (!font.characters.containsKey(c)) {
          wordWidth += font.base ~/ 2;
        } else {
          wordWidth += font.characters[c]!.xAdvance;
        }
      }
      if ((lineWidth + wordWidth) < width) {
        line += w;
        lineWidth += wordWidth;
      } else {
        lines.add(_Line(line, lineWidth));
        line = w;
        lineWidth = wordWidth;
      }
    }
    if (line.isNotEmpty) lines.add(_Line(line, lineWidth));
    return lines;
  }

  /// Renders a [Card] to a [Uint8List] containing the PNG image.
  Future<Uint8List> renderCard(Card card) async {
    final power = _PowerSprite(power: card.power);
    final elementIcon = _ElementIcon(card.suit);

    try {
      final assets = await Future.wait([
        _getFile(Uri.parse(card.image)),
        _getFile(
          Uri.parse(
            card.rarity
                ? _holoFrameAssets[card.suit]!
                : _elementFrameAssets[card.suit]!,
          ),
        ),
        _getFile(Uri.parse(_elementIconAssets[card.suit]!)),
        _getFile(Uri.parse(_powerSpriteAsset)),
        _getFile(Uri.parse(_descriptionFontAsset)),
        _getFile(Uri.parse(_titleFontAsset)),
      ]);

      final characterCmd = _createCommand()
        ..decodePng(assets.first)
        ..copyResize(
          width: _characterSize.width,
          height: _characterSize.height,
          interpolation: Interpolation.cubic,
        );
      final frameCmd = _createCommand()..decodePng(assets[1]);
      final elementIconCmd = _createCommand()..decodePng(assets[2]);
      final powerSpriteCmd = _createCommand()..decodePng(assets[3]);
      final descriptionFont = _parseFont(assets[4]);
      final titleFont = _parseFont(assets[5]);

      final compositionCommand = _createCommand()
        ..createImage(
          width: _cardSize.width,
          height: _cardSize.height,
          numChannels: 4,
        )
        ..convert(numChannels: 4, alpha: 0)
        ..compositeImage(
          characterCmd,
          dstX: _characterPosition.first,
          dstY: _characterPosition.last,
        )
        ..compositeImage(
          frameCmd,
          dstX: 0,
          dstY: 0,
        );

      if (card.rarity) {
        compositionCommand
          ..filter(rainbowFilter)
          ..chromaticAberration(shift: 2);
      }

      final titleLines = _splitText(card.name, titleFont, _cardSize.width);

      final titleLineHeight = titleFont.lineHeight;
      var titlePosition = _titlePosition;
      if (titleLines.length > 1) titlePosition -= titleLineHeight ~/ 2;

      for (var i = 0; i < titleLines.length; i++) {
        final line = titleLines[i];
        compositionCommand.drawString(
          line.text.trimRight(),
          font: titleFont,
          x: ((_cardSize.width - line.width) / 2).round(),
          y: titlePosition + ((titleLineHeight - 15) * i),
        );
      }

      final lineHeight = descriptionFont.lineHeight;
      final descriptionLines =
          _splitText(card.description, descriptionFont, _descriptionSize.width);

      for (var i = 0; i < descriptionLines.length; i++) {
        final line = descriptionLines[i];
        compositionCommand.drawString(
          line.text.trimRight(),
          font: descriptionFont,
          x: _descriptionPosition.first +
              ((_descriptionSize.width - line.width) / 2).round(),
          y: _descriptionPosition.last + (lineHeight * i),
        );
      }
      compositionCommand
        ..compositeImage(
          elementIconCmd,
          dstX: elementIcon.dstX,
          dstY: elementIcon.dstY,
        )
        ..compositeImage(
          powerSpriteCmd,
          dstX: power.dstX,
          dstY: power.dstY,
          srcX: power.srcX,
          srcY: power.srcY,
          srcW: power.width,
          srcH: power.height,
          dstW: power.width,
          dstH: power.height,
        )
        ..encodePng();

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

      final compositionCommand = _createCommand()
        ..createImage(
          width: _cardSize.width * cards.length + (20 * (cards.length - 1)),
          height: _cardSize.height,
          numChannels: 4,
        );

      for (var i = 0; i < cards.length; i++) {
        compositionCommand.compositeImage(
          cardCommands[i],
          dstX: (_cardSize.width + 20) * i,
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

class _Size {
  const _Size({required this.height, required this.width});
  final int height;
  final int width;
}

class _PowerSprite {
  const _PowerSprite({
    required this.power,
  });
  final int power;
  static const size = _powerSpriteSize;

  int get width => size.width;
  int get height => size.height;
  int get srcX => (power % 10) * size.width;
  int get srcY => (power ~/ 10) * size.height;
  int get dstX => (power == 100)
      ? _powerSpritePosition.first - 6
      : _powerSpritePosition.first;
  int get dstY => _powerSpritePosition.last;
}

class _ElementIcon {
  const _ElementIcon(this.suit);
  final Suit suit;

  int get dstX => _elementIconPositions[suit]!.first;
  int get dstY => _elementIconPositions[suit]!.last;
}

class _Line {
  const _Line(this.text, this.width);
  final String text;
  final int width;
}
