import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:top_dash/style/palette.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: const Center(child: Text('Top Dash Game')),
    );
  }
}
