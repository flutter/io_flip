import 'package:card_renderer/card_renderer.dart';
import 'package:image/image.dart';
import 'package:test/test.dart';

void main() {
  group('rainbowFilter', () {
    final expected = Command()
      ..decodeImageFile('test/src/rainbow_filter.png')
      ..encodePng();

    setUpAll(() async {
      await expected.execute();
    });

    test('applies rainbow on top of image', () async {
      final command = Command()
        ..createImage(width: 500, height: 500)
        ..fill(color: ColorRgb8(128, 128, 128))
        ..filter(rainbowFilter)
        ..encodePng();
      await command.execute();

      expect(command.outputBytes, equals(expected.outputBytes));
    });
  });
}
