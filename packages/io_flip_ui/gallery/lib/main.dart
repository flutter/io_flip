import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';
import 'package:gallery/stories.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

void main() {
  final dashbook = Dashbook(
    title: 'I/O Flip Dashbook',
    theme: IoFlipTheme.themeData.copyWith(
      // Edits to make drawer and its text visible with the dark theme.
      cardColor: IoFlipColors.seedBlack,
      expansionTileTheme:
          const ExpansionTileThemeData(textColor: IoFlipColors.seedWhite),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: IoFlipColors.seedWhite),
      ),
    ),
  );

  addStories(dashbook);

  runApp(dashbook);
}
