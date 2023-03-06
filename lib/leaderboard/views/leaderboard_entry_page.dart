import 'package:flutter/material.dart';
import 'package:top_dash/leaderboard/leaderboard.dart';

class LeaderboardEntryPage extends StatelessWidget {
  const LeaderboardEntryPage({super.key});

  factory LeaderboardEntryPage.routeBuilder(_, __) {
    return const LeaderboardEntryPage(key: Key('leaderboard'));
  }

  @override
  Widget build(BuildContext context) {
    return const LeaderboardEntryView();
  }
}
