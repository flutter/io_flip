import 'dart:math' as math;

import 'package:image/image.dart';

/// Applies a rainbow filter to the image.
Image rainbowFilter(Image image) {
  const saturation = 0.95;
  for (final frame in image.frames) {
    for (final p in frame) {
      var hue = p.xNormalized / 1.75;
      hue = hue.remainder(1);
      final srcColor = rgbToHsl(p.r, p.g, p.b);
      final lightness = 0.5 + 0.1 * srcColor[2];
      final color = hslToRgb(hue, saturation, lightness);
      final strength = 0.4 * math.cos((p.yNormalized - 0.25) * math.pi);
      p
        ..r = p.r * (1 - strength) + color[0] * strength
        ..g = p.g * (1 - strength) + color[1] * strength
        ..b = p.b * (1 - strength) + color[2] * strength;
    }
  }

  return image;
}
