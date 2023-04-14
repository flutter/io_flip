import 'dart:math' show sin;

import 'package:image/image.dart';

/// Applies a rainbow filter to the image.
Image rainbowFilter(Image image) {
  const saturation = 0.95;
  const lightness = 0.8;
  for (final frame in image.frames) {
    for (final p in frame) {
      var hue = p.xNormalized +
          sin((p.xNormalized - 3.0) * (p.yNormalized + 2.0) * 1.8);
      hue = hue.remainder(1);
      final color = hslToRgb(hue, saturation, lightness);
      p
        ..r = p.r * 0.7 + color[0] * 0.3
        ..g = p.g * 0.7 + color[1] * 0.3
        ..b = p.b * 0.7 + color[2] * 0.3
        ..a = p.a * 0.7 + 255 * 0.3;
    }
  }

  return image;
}
