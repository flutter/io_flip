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
      body: Align(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(TopDashSpacing.xlg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _MainMenuScreenView(key: Key('main menu view')),
                _Footer(key: Key('main menu footer')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MainMenuScreenView extends StatelessWidget {
  const _MainMenuScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        /// Todo(hugo): Replace with Hero image
        Expanded(
          flex: 6,
          child: DecoratedBox(decoration: BoxDecoration(color: Colors.red)),
        ),
        Expanded(
          flex: 6,
          child: LeaderboardView(),
        ),
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }
}

