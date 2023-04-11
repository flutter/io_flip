import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_dash/leaderboard/leaderboard.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LeaderboardBloc>(
      create: (context) {
        final leaderboardResource = context.read<LeaderboardResource>();
        return LeaderboardBloc(
          leaderboardResource: leaderboardResource,
        )..add(const LeaderboardRequested());
      },
      child: const LeaderboardView(),
    );
  }
}
