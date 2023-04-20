import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/gen/assets.gen.dart';
import 'package:top_dash/how_to_play/view/how_to_play_dialog.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/leaderboard/leaderboard.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  factory MainMenuScreen.routeBuilder(_, __) {
    return const MainMenuScreen(
      key: Key('main menu'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: Stack(
        children: [
          const Align(
            alignment: Alignment.topCenter,
            child: _MainMenuScreenView(key: Key('main menu view')),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IoFlipBottomBar(
              leading: RoundedButton.svg(
                Assets.icons.info,
                onPressed: () {
                  // TODO(all): add info screen
                },
              ),
              middle: RoundedButton.text(
                l10n.play,
                onPressed: () {
                  GoRouter.of(context).go('/prompt');
                },
              ),
              trailing: RoundedButton.icon(
                Icons.question_mark_rounded,
                onPressed: () => HowToPlayDialog.show(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MainMenuScreenView extends StatelessWidget {
  const _MainMenuScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset(
            Assets.images.main.path,
            height: 312,
            fit: BoxFit.fitHeight,
          ),
          const LeaderboardPage(),
          const SizedBox(height: TopDashSpacing.xxlg),
        ],
      ),
    );
  }
}
