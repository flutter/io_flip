import 'package:flutter/material.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class LeaderboardPlayers extends StatelessWidget {
  const LeaderboardPlayers({
    required this.players,
    super.key,
  });

  final List<LeaderboardPlayer> players;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final player in players) ...[
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

    switch (index) {
      case 0:
        color = TopDashColors.seedGold;
        break;
      case 1:
        color = TopDashColors.seedSilver;
        break;
      case 2:
        color = TopDashColors.seedBronze;
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
                child: Text(
                  (index + 1).toString(),
                  style: TopDashTextStyles.cardNumberXS,
                ),
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
