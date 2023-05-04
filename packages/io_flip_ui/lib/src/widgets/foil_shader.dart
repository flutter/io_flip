import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

/// {@template foil_shader}
/// A widget that applies a "foil" shader to its child. The foil shader
/// is a shader that applies an effect similar to a shiny metallic card.
/// {@endtemplate}
class FoilShader extends StatelessWidget {
  /// {@macro foil_shader}
  const FoilShader({
    required this.child,
    super.key,
    this.dx = 0,
    this.dy = 0,
    this.package = 'io_flip_ui',
  });

  /// The optional x offset of the foil shader.
  ///
  /// This can be used for parallax.
  final double dx;

  /// The optional y offset of the foil shader.
  ///
  /// This can be used for parallax.
  final double dy;

  /// The name of the package from which the shader is included.
  ///
  /// This is used to resolve the shader asset key.
  final String? package;

  /// The child widget to apply the foil shader to.
  final Widget child;

  static const String _assetPath = 'shaders/foil.frag';

  String get _assetKey =>
      package == null ? _assetPath : 'packages/$package/$_assetPath';

  @override
  Widget build(BuildContext context) {
    late final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    return ShaderBuilder(
      assetKey: _assetKey,
      (context, shader, child) {
        return AnimatedSampler(
          (image, size, canvas) {
            shader
              ..setFloat(0, image.width.toDouble() / devicePixelRatio)
              ..setFloat(1, image.height.toDouble() / devicePixelRatio)
              ..setFloat(2, dx)
              ..setFloat(3, dy)
              ..setImageSampler(0, image);
            canvas.drawRect(
              Offset.zero & size,
              Paint()..shader = shader,
            );
          },
          child: child!,
        );
      },
      child: child,
    );
  }
}
