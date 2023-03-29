import 'package:flutter/material.dart';
import 'package:gallery/story_scaffold.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class AppColorsStory extends StatelessWidget {
  const AppColorsStory({super.key});

  @override
  Widget build(BuildContext context) {
    final colorItems = [
      const _ColorItem(name: 'Black', color: TopDashColors.black),
      const _ColorItem(name: 'Ink', color: TopDashColors.ink),
      const _ColorItem(name: 'Draw gray', color: TopDashColors.drawGrey),
      const _ColorItem(
        name: 'Background Leaderboard Entry',
        color: TopDashColors.backgroundLeaderboardEntry,
      ),
      const _ColorItem(name: 'Silver', color: TopDashColors.silver),
      const _ColorItem(name: 'White', color: TopDashColors.white),
      const _ColorItem(
        name: 'Transparent White',
        color: TopDashColors.transparentWhite,
      ),
      const _ColorItem(
        name: 'Background Main',
        color: TopDashColors.backgroundMain,
      ),
      const _ColorItem(name: 'Light Blue 99', color: TopDashColors.lightBlue99),
      const _ColorItem(name: 'Dark Pen', color: TopDashColors.darkPen),
      const _ColorItem(name: 'Blue 50', color: TopDashColors.blue50),
      const _ColorItem(name: 'Seed Blue', color: TopDashColors.seedBlue),
      const _ColorItem(name: 'Main Blue', color: TopDashColors.mainBlue),
      const _ColorItem(name: 'Light Blue 60', color: TopDashColors.lightBlue60),
      const _ColorItem(name: 'Main Red', color: TopDashColors.mainRed),
      const _ColorItem(name: 'Seed Red', color: TopDashColors.seedRed),
      const _ColorItem(name: 'Gold', color: TopDashColors.gold),
      const _ColorItem(name: 'Bronze', color: TopDashColors.bronze),
    ];

    return StoryScaffold(
      title: 'Colors',
      body: SingleChildScrollView(
        child: Wrap(
          children: colorItems,
        ),
      ),
    );
  }
}

class _ColorItem extends StatelessWidget {
  const _ColorItem({
    required this.name,
    required this.color,
  });

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(name),
          const SizedBox(height: 16),
          _ColorSquare(color: color),
        ],
      ),
    );
  }
}

class _ColorSquare extends StatelessWidget {
  const _ColorSquare({required this.color});

  final Color color;

  TextStyle get textStyle {
    return TextStyle(
      color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
    );
  }

  String get hexCode {
    if (color.value.toRadixString(16).length <= 2) {
      return '--';
    } else {
      return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Stack(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: DecoratedBox(
              decoration: BoxDecoration(color: color, border: Border.all()),
            ),
          ),
          Positioned.fill(
            child: Center(child: Text(hexCode, style: textStyle)),
          ),
        ],
      ),
    );
  }
}
