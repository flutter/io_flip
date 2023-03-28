import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

/// {@template how_to_play_button}
/// Button with a question mark icon that goes to the how to play page.
/// {@endtemplate}
class HowToPlayButton extends StatelessWidget {
  /// {@macro how_to_play_button}
  const HowToPlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    return RoundedButton.icon(
      const Icon(Icons.question_mark_rounded),
      backgroundColor: TopDashColors.white,
      onPressed: () => GoRouter.of(context).go('/how_to_play'),
    );
  }
}
