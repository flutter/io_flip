import 'package:flutter/material.dart';
import 'package:top_dash_ui/gen/assets.gen.dart';

/// {@template io_flip_scaffold}
/// IO Flip scaffold that adds the background pattern.
/// {@endtemplate}
class IoFlipScaffold extends StatelessWidget {
  /// {@macro io_flip_scaffold}
  const IoFlipScaffold({
    super.key,
    this.body,
    this.bottomBar,
  });

  /// The primary content of the scaffold.
  final Widget? body;

  /// The bottom bar of the scaffold.
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.none,
            image: AssetImage(
              Assets.images.backgroundPattern.path,
              package: 'top_dash_ui',
            ),
          ),
        ),
        child: Column(
          children: [
            if (body != null) Expanded(child: body!),
            if (bottomBar != null) bottomBar!,
          ],
        ),
      ),
    );
  }
}
