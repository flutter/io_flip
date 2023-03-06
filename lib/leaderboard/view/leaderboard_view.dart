import 'package:flutter/material.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/leaderboard/leaderboard.dart';

// TODO(willhlas): update hard coded values with values from the
//  design system once it is complete.

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
      l10n.leaderboardMostWinsCategory: const LeaderboardPlayers(),
    };

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [for (final tab in tabs.keys) Tab(text: tab)],
            onTap: (i) => setState(() => index = i),
          ),
          const SizedBox(height: 16),
          tabs.values.elementAt(index),
        ],
      ),
    );
  }
}
