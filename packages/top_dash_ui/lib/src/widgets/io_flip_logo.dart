import 'package:flutter/widgets.dart';
import 'package:top_dash_ui/gen/assets.gen.dart';

/// {@template io_flip_logo}
/// IO Flip main logo.
/// {@endtemplate}
class IoFlipLogo extends StatelessWidget {
  /// {@macro io_flip_logo}
  IoFlipLogo({
    this.width,
    this.height,
    super.key,
  }) : _svg = Assets.images.ioFlipLogo;

  /// White version of the IO Flip logo.
  IoFlipLogo.white({
    this.width,
    this.height,
    super.key,
  }) : _svg = Assets.images.ioFlipLogo03;

  /// The width to use for the logo.
  final double? width;

  /// The height to use for the logo.
  final double? height;

  final SvgGenImage _svg;

  @override
  Widget build(BuildContext context) {
    return _svg.svg(
      width: width,
      height: height,
    );
  }
}
