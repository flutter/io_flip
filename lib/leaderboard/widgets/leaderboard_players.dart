import 'package:flutter/material.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class LeaderboardPlayers extends StatelessWidget {
  const LeaderboardPlayers({super.key});

  // TODO(willhlas): replace with real data once available.
  static const _playerList = [
    _Player(index: 0, initials: 'AAA', wins: 220),
    _Player(index: 1, initials: 'BBB', wins: 218),
    _Player(index: 2, initials: 'CCC', wins: 172),
    _Player(index: 3, initials: 'DDD', wins: 154),
    _Player(index: 4, initials: 'EEE', wins: 152),
    _Player(index: 5, initials: 'FFF', wins: 144),
    _Player(index: 6, initials: 'GGG', wins: 127),
    _Player(index: 7, initials: 'HHH', wins: 99),
    _Player(index: 8, initials: 'III', wins: 97),
    _Player(index: 9, initials: 'JJJ', wins: 81),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final player in _playerList) ...[
          player,
          const SizedBox(height: TopDashSpacing.md),
        ],
      ],
    );
  }
}

class _Player extends StatelessWidget {
  const _Player({
    required this.index,
    required this.initials,
    required this.wins,
  });

  final String initials;
  final int wins;
  final int index;

  @override
  Widget build(BuildContext context) {
    var color = Colors.transparent;

    switch (index) {
      case 0:
        color = const Color(0xFFF9A52F);
        break;
      case 1:
        color = const Color(0xFFE0E4E3);
        break;
      case 2:
        color = const Color(0xFFC47542);
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Text((index + 1).toString()),
            ),
            const SizedBox(width: TopDashSpacing.lg),
            Text(initials, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Text(
          wins.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
