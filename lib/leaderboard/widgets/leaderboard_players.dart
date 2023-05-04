import 'package:flutter/material.dart';
import 'package:io_flip/gen/assets.gen.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

class LeaderboardPlayers extends StatelessWidget {
  const LeaderboardPlayers({
    required this.players,
    super.key,
  });

  final List<LeaderboardPlayer> players;

  @override
  Widget build(BuildContext context) {
    final topPlayers = players.length >= 3 ? players.sublist(0, 3) : players;
    final restPlayers =
        players.length >= 3 ? players.sublist(3) : <LeaderboardPlayer>[];
    return Column(
      children: [
        for (final player in topPlayers) ...[
          const SizedBox(height: TopDashSpacing.md),
          player,
        ],
        if (restPlayers.isNotEmpty) ...[
          const Divider(
            thickness: 2,
            color: TopDashColors.seedGrey30,
          ),
        ],
        for (final player in restPlayers) ...[
          player,
          const SizedBox(height: TopDashSpacing.md),
        ],
      ],
    );
  }
}

class LeaderboardPlayer extends StatelessWidget {
  const LeaderboardPlayer({
    required this.index,
    required this.initials,
    required this.value,
    super.key,
  });

  final int index;
  final String initials;
  final int value;

  @override
  Widget build(BuildContext context) {
    var color = Colors.transparent;
    Widget number = Text(
      (index + 1).toString(),
      style: TopDashTextStyles.cardNumberXS,
    );

    switch (index) {
      case 0:
        color = TopDashColors.seedGold;
        number = Assets.images.leaderboard.num1.image();
        break;
      case 1:
        color = TopDashColors.seedSilver;
        number = Assets.images.leaderboard.num2.image();
        break;
      case 2:
        color = TopDashColors.seedBronze;
        number = Assets.images.leaderboard.num3.image();
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TopDashSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: number,
              ),
              const SizedBox(width: TopDashSpacing.xlg),
              Text(initials, style: TopDashTextStyles.headlineH6),
            ],
          ),
          Text(
            value.toString(),
            style: TopDashTextStyles.buttonLG,
          ),
        ],
      ),
    );
  }
}
