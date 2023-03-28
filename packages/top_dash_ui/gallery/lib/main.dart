import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';
import 'package:gallery/stories.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

void main() {
  final dashbook = Dashbook(
    title: 'Top Dashbook',
    theme: TopDashTheme.themeData,
  );

  addStories(dashbook);

  runApp(dashbook);
}
