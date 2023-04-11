import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/gen/assets.gen.dart';
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
    return const Scaffold(
      backgroundColor: TopDashColors.seedWhite,
      body: Stack(
        children: [
          Align(
            child: _MainMenuScreenView(key: Key('main menu view')),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Align(
              child: _Footer(key: Key('main menu footer')),
            ),
          )
        ],
      ),
    );
  }
}

class _MainMenuScreenView extends StatelessWidget {
  const _MainMenuScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (context, widget) => const PortraitMenuView(),
      large: (context, widget) => const LandscapeMenuView(),
    );
  }
}

class PortraitMenuView extends StatelessWidget {
  const PortraitMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          _MainImage(key: Key('main menu image')),
          LeaderboardPage(),
          SizedBox(height: TopDashSpacing.xxlg),
        ],
      ),
    );
  }
}

@visibleForTesting
class LandscapeMenuView extends StatelessWidget {
  const LandscapeMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TopDashSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _MainImage(key: Key('main menu image')),
          Flexible(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 2 * TopDashSpacing.xxxlg,
              ),
            ),
          ),
          const SingleChildScrollView(
            child: LeaderboardPage(),
          ),
        ],
      ),
    );
  }
}

class _MainImage extends StatelessWidget {
  const _MainImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 590),
          child: Image.asset(
            Assets.images.main.path,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: TopDashSpacing.xxlg),
          child: Text(
            context.l10n.menuCatchPhrase,
            style: TopDashTextStyles.headlineH6Light,
          ),
        )
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({super.key});

  static const Widget _gap = SizedBox(width: TopDashSpacing.md);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ColoredBox(
      color: TopDashColors.seedWhite,
      child: Padding(
        padding: const EdgeInsets.all(TopDashSpacing.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundedButton.icon(
              const Icon(Icons.more_horiz_rounded),
              backgroundColor: TopDashColors.seedWhite,
              onPressed: () => GoRouter.of(context).push('/settings'),
            ),
            _gap,
            RoundedButton.icon(
              const Icon(Icons.share),
              backgroundColor: TopDashColors.seedWhite,
              onPressed: () => GoRouter.of(context).goNamed('share'),
            ),
            _gap,
            RoundedButton.icon(
              const Icon(Icons.question_mark_rounded),
              backgroundColor: TopDashColors.seedWhite,
              onPressed: () => GoRouter.of(context).go('/how_to_play'),
            ),
            _gap,
            RoundedButton.text(
              l10n.play,
              onPressed: () {
                GoRouter.of(context).go('/prompt');
              },
            ),
          ],
        ),
      ),
    );
  }
}
