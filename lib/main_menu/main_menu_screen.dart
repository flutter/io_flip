import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:top_dash/audio/audio_controller.dart';
import 'package:top_dash/audio/sounds.dart';
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
    return Scaffold(
      backgroundColor: TopDashColors.backgroundMain,
      body: Stack(
        children: [
          Align(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: const _MainMenuScreenView(key: Key('main menu view')),
            ),
          ),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _Footer(key: Key('main menu footer')),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = MediaQuery.of(context).size;
        final isPortrait = size.width < size.height || size.width < 1050;
        return isPortrait
            ? SingleChildScrollView(
                child: Column(
                  children: const [
                    _MainImage(key: Key('main menu image')),
                    LeaderboardView(),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(TopDashSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _MainImage(key: Key('main menu image')),
                    LeaderboardView(),
                  ],
                ),
              );
      },
    );
  }
}

class _MainImage extends StatelessWidget {
  const _MainImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 590),
          child: Image.asset(
            'assets/images/bird.png',
            fit: BoxFit.fitWidth,
          ),
        ),
        const SizedBox(height: TopDashSpacing.lg),
        const Text('A global, AI-powered card collection game.'),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final audioController = context.watch<AudioController>();

    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(TopDashSpacing.md),
        child: Row(
          children: [
            IconButton(
              onPressed: () => GoRouter.of(context).push('/settings'),
              icon: const Icon(Icons.settings),
            ),
            OutlinedButton(
              onPressed: () {
                audioController.playSfx(SfxType.buttonTap);
                GoRouter.of(context).go('/draft');
              },
              child: Text(l10n.play),
            ),
            IconButton(
              onPressed: () => GoRouter.of(context).goNamed('share'),
              icon: const Icon(Icons.share),
            ),
          ],
        ),
      ),
    );
  }
}
