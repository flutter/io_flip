import 'package:flutter/material.dart';
import 'package:top_dash/l10n/l10n.dart';

class LeaderboardPlayers extends StatelessWidget {
  const LeaderboardPlayers({super.key});

  // TODO(willhlas): replace with real data once available.
  static const _playerList = [
    _Player(initials: 'AAA', wins: 220),
    _Player(initials: 'BBB', wins: 218),
    _Player(initials: 'CCC', wins: 172),
    _Player(initials: 'DDD', wins: 154),
    _Player(initials: 'EEE', wins: 152),
    _Player(initials: 'FFF', wins: 144),
    _Player(initials: 'GGG', wins: 127),
    _Player(initials: 'HHH', wins: 99),
    _Player(initials: 'III', wins: 97),
    _Player(initials: 'JJJ', wins: 81),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final player in _playerList) ...[
          player,
          const SizedBox(height: 2),
        ],
      ],
    );
  }
}

class _Player extends StatelessWidget {
  const _Player({
    required this.initials,
    required this.wins,
  });

  final String initials;
  final int wins;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(initials),
        Text(l10n.leaderboardPlayerWins(wins)),
      ],
    );
  }
}
