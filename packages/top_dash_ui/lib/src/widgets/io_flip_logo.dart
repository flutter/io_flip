import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:top_dash_ui/gen/assets.gen.dart';

/// {@template io_flip_logo}
/// IO Flip main logo.
/// {@endtemplate}
class IoFlipLogo extends StatelessWidget {
  /// {@macro io_flip_logo}
  const IoFlipLogo({
    this.width,
    this.height,
    super.key,
  });

  /// The width to use for the logo.
  final double? width;

  /// The height to use for the logo.
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      Assets.images.ioFlipLogo,
      package: 'top_dash_ui',
      width: width,
      height: height,
    );
  }
}
