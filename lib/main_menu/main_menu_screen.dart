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
        children: const [
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isPortrait = constraints.maxWidth < constraints.maxHeight ||
            constraints.maxWidth < 1050;
        return isPortrait
            ? const PortraitMenuView()
            : const LandscapeMenuView();
      },
    );
  }
}

class PortraitMenuView extends StatelessWidget {
  const PortraitMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          _MainImage(key: Key('main menu image')),
          LeaderboardView(),
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
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            _MainImage(key: Key('main menu image')),
            SingleChildScrollView(
              child: LeaderboardView(),
            ),
          ],
        ),
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
            'assets/images/bird.png',
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: TopDashSpacing.xxlg),
          child: Text(
            context.l10n.menuCatchPhrase,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        )
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({super.key});

  static const Widget _gap = SizedBox(width: TopDashSpacing.sm);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final audioController = context.watch<AudioController>();

    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(TopDashSpacing.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _RoundedButton(
              icon: const Icon(Icons.settings),
              onPressed: () => GoRouter.of(context).push('/settings'),
            ),
            _gap,
            _RoundedButton(
              icon: const Icon(Icons.share),
              onPressed: () => GoRouter.of(context).goNamed('share'),
            ),
            _gap,
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: TopDashColors.mainBlue,
                elevation: 2,
                side: const BorderSide(),
                shadowColor: Colors.black,
              ),
              onPressed: () {
                audioController.playSfx(SfxType.buttonTap);
                GoRouter.of(context).go('/draft');
              },
              child: Text(
                l10n.play,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundedButton extends StatelessWidget {
  const _RoundedButton({required this.icon, required this.onPressed});

  final Icon icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        side: const BorderSide(width: 2),
        shadowColor: Colors.black,
        shape: const CircleBorder(),
      ),
      onPressed: () => onPressed,
      child: icon,
    );
  }
}

