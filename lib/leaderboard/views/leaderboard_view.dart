import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_flip/l10n/l10n.dart';
import 'package:io_flip/leaderboard/leaderboard.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    const highlightColor = IoFlipColors.seedYellow;

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

    return Padding(
      padding: const EdgeInsets.all(IoFlipSpacing.xlg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: Column(
          children: [
            Text(
              l10n.leaderboardLongestStreak,
              style: IoFlipTextStyles.buttonSM.copyWith(color: highlightColor),
            ),
            const SizedBox(height: IoFlipSpacing.sm),
            const Divider(thickness: 2, color: highlightColor),
            const SizedBox(height: IoFlipSpacing.xs),
            LeaderboardPlayers(
              players: longestStreak
                  .map(
                    (e) => LeaderboardPlayer(
                      index: longestStreak.indexOf(e),
                      initials: e.initials ?? '',
                      value: e.longestStreak,
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
