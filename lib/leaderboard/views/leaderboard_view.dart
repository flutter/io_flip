import 'package:flutter/material.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/leaderboard/leaderboard.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class LeaderboardView extends StatefulWidget {
  const LeaderboardView({super.key});

  @override
  State<LeaderboardView> createState() => LeaderboardViewState();
}

class LeaderboardViewState extends State<LeaderboardView> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final tabs = {
      l10n.leaderboardLongestStreak: const LeaderboardPlayers(),
      l10n.leaderboardMostWins: const LeaderboardPlayers(),
    };

    return DefaultTabController(
      length: tabs.length,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          children: [
            TabBar(
              tabs: [for (final tab in tabs.keys) Tab(text: tab)],
              onTap: (i) => setState(() => index = i),
            ),
            const SizedBox(height: TopDashSpacing.lg),
            tabs.values.elementAt(index),
          ],
        ),
      ),
    );
  }
}
