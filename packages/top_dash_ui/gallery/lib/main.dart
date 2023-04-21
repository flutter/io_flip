import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';
import 'package:gallery/stories.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

void main() {
  final dashbook = Dashbook(
    title: 'I/O Flip Dashbook',
    theme: TopDashTheme.themeData.copyWith(
      // Edits to make drawer and its text visible with the dark theme.
      cardColor: TopDashColors.seedBlack,
      expansionTileTheme:
          const ExpansionTileThemeData(textColor: TopDashColors.seedWhite),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: TopDashColors.seedWhite),
      ),
    ),
  );

  addStories(dashbook);

  runApp(dashbook);
}
