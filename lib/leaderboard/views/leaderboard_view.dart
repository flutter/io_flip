import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final bloc = context.watch<LeaderboardBloc>();
    final state = bloc.state;
    final l10n = context.l10n;
    final leaderboard = state.leaderboard;

    if (state.status == LeaderboardStateStatus.loading ||
        state.status == LeaderboardStateStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == LeaderboardStateStatus.failed || leaderboard == null) {
      return Center(child: Text(l10n.leaderboardFailedToLoad));
    }

    final longestStreak = leaderboard.scoreCardsWithLongestStreak;
    final mostWins = leaderboard.scoreCardsWithMostWins;

    final tabs = {
      l10n.leaderboardLongestStreak: LeaderboardPlayers(
        players: longestStreak.map((e) {
          return LeaderboardPlayer(
            index: longestStreak.indexOf(e),
            initials: e.initials ?? '',
            value: e.longestStreak,
          );
        }).toList(),
      ),
      l10n.leaderboardMostWins: LeaderboardPlayers(
        players: mostWins.map((e) {
          return LeaderboardPlayer(
            index: mostWins.indexOf(e),
            initials: e.initials ?? '',
            value: e.wins,
          );
        }).toList(),
      ),
    };

    return Padding(
      padding: const EdgeInsets.all(TopDashSpacing.md),
      child: DefaultTabController(
        length: tabs.length,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            children: [
              TabBar(
                labelStyle: TopDashTextStyles.buttonSMCaps,
                tabs: [for (final tab in tabs.keys) Tab(text: tab)],
                onTap: (i) => setState(() => index = i),
              ),
              const SizedBox(height: TopDashSpacing.lg),
              tabs.values.elementAt(index),
            ],
          ),
        ),
      ),
    );
  }
}
