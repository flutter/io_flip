import 'dart:typed_data';
import 'package:card_renderer/card_renderer.dart';
import 'package:game_domain/game_domain.dart';
import 'package:http/http.dart';
import 'package:image/image.dart';

// Component Sizes
const _cardSize = _Size(width: 500, height: 655);
const _characterSize = _Size(width: 434, height: 408);
const _descriptionSize = _Size(width: 404, height: 112);
const _powerSpriteSize = _Size(width: 170, height: 97);

// Component Positions
const _titlePosition = 445;
const _characterPosition = 33;
const _powerSpritePosition = [322, 65];
const _descriptionPosition = [48, 522];
const _elementIconPositions = {
  Suit.air: [318, 19],
  Suit.earth: [314, 7],
  Suit.fire: [336, 3],
  Suit.water: [338, 5],
  Suit.metal: [328, 37],
};

// Assets
const _powerSpriteAsset = 'http://127.0.0.1:8080/assets/power-sprites.png';
const _titleFontAsset = 'http://127.0.0.1:8080/assets/Saira-Bold-42.ttf.zip';
const _descriptionFontAsset =
    'http://127.0.0.1:8080/assets/GoogleSans-21.ttf.zip';
const _elementIconAssets = {
  Suit.air: 'http://127.0.0.1:8080/assets/icon-air.png',
  Suit.earth: 'http://127.0.0.1:8080/assets/icon-ground.png',
  Suit.fire: 'http://127.0.0.1:8080/assets/icon-fire.png',
  Suit.water: 'http://127.0.0.1:8080/assets/icon-water.png',
  Suit.metal: 'http://127.0.0.1:8080/assets/icon-metal.png',
};
const _elementFrameAssets = {
  Suit.air: 'http://127.0.0.1:8080/assets/card-air.png',
  Suit.earth: 'http://127.0.0.1:8080/assets/card-ground.png',
  Suit.fire: 'http://127.0.0.1:8080/assets/card-fire.png',
  Suit.water: 'http://127.0.0.1:8080/assets/card-water.png',
  Suit.metal: 'http://127.0.0.1:8080/assets/card-metal.png',
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
    final words = string.split(RegExp(r"\s+"));
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
      for (var c in chars) {
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
        _getFile(Uri.parse(_elementFrameAssets[card.suit]!)),
        _getFile(Uri.parse(_elementIconAssets[card.suit]!)),
        _getFile(Uri.parse(_powerSpriteAsset)),
        _getFile(Uri.parse(_descriptionFontAsset)),
        _getFile(Uri.parse(_titleFontAsset)),
      ]);

      final characterCmd = _createCommand()..decodePng(assets.first);
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
          dstX: _characterPosition,
          dstY: _characterPosition,
          dstW: _characterSize.width,
          dstH: _characterSize.height,
        )
        ..compositeImage(
          frameCmd,
          dstX: 0,
          dstY: 0,
        )
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
        );

      final lineHeight = descriptionFont.lineHeight;

      final titleLines = _splitText(card.name, titleFont, _cardSize.width);

      for (var i = 0; i < titleLines.length; i++) {
        final line = titleLines[i];
        compositionCommand.drawString(
          line.text.trimRight(),
          font: titleFont,
          x: ((_cardSize.width - line.width) / 2).round(),
          y: _titlePosition + ((lineHeight + 5) * i),
        );
      }

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
          width: _cardSize.width * cards.length,
          height: _cardSize.height + offsetModifier * angleValue,
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
          dstX: (_cardSize.width * i) + offsets[i]![0],
          dstY: offsets[i]![1],
          dstW: _cardSize.width + offsetModifier * angles[i]!.abs(),
          dstH: _cardSize.height + offsetModifier * angles[i]!.abs(),
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
  int get dstX => _powerSpritePosition.first;
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
