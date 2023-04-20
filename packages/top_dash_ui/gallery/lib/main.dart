import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';
import 'package:gallery/stories.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

void main() {
  final dashbook = Dashbook(
    title: 'I/O Flip Dashbook',
    theme: TopDashTheme.themeData.copyWith(
      cardColor: TopDashColors.seedBlack,
    ),
  );

  addStories(dashbook);

  runApp(dashbook);
}
