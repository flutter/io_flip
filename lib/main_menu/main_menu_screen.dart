// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:top_dash/audio/audio_controller.dart';
import 'package:top_dash/audio/sounds.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/leaderboard/leaderboard.dart';
import 'package:top_dash/settings/settings.dart';
import 'package:top_dash/style/palette.dart';

// TODO(willhlas): remove default flutter game template code
//  once main menu design is complete and replace hard coded values with
//  values from the design system.

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  factory MainMenuScreen.routeBuilder(_, __) {
    return const MainMenuScreen(
      key: Key('main menu'),
    );
  }

  static const _gap = SizedBox(height: 16);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.watch<Palette>();
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: SingleChildScrollView(
        child: Align(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: _Header(),
                  ),
                  const LeaderboardView(),
                  _gap,
                  OutlinedButton(
                    onPressed: () {
                      audioController.playSfx(SfxType.buttonTap);
                      GoRouter.of(context).go('/draft');
                    },
                    child: Text(l10n.play),
                  ),
                  _gap,
                  FilledButton(
                    onPressed: () => GoRouter.of(context).push('/settings'),
                    child: const Text('Settings'),
                  ),
                  _gap,
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: ValueListenableBuilder<bool>(
                      valueListenable: settingsController.muted,
                      builder: (context, muted, child) {
                        return IconButton(
                          onPressed: settingsController.toggleMuted,
                          icon:
                              Icon(muted ? Icons.volume_off : Icons.volume_up),
                        );
                      },
                    ),
                  ),
                  _gap,
                  const Text('Music by Mr Smith'),
                  _gap,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            l10n.ioBash,
            style: textTheme.displayLarge,
          ),
        ),
        const SizedBox(width: 3),
        const IconButton(
          onPressed: null,
          icon: Icon(Icons.help_outline),
        )
      ],
    );
  }
}
