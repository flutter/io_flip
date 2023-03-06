import 'package:flutter/material.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

/// {@template top_dash_theme}
/// Top Dash theme.
/// {@endtemplate}
class TopDashTheme {
  /// [ThemeData] for Top Dash.
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _colorScheme,
      textTheme: _textTheme,
    );
  }

  static ColorScheme get _colorScheme {
    return ColorScheme.fromSeed(
      seedColor: TopDashColors.darkPen,
      background: TopDashColors.backgroundMain,
    );
  }

  static TextTheme get _textTheme {
    return const TextTheme(
      bodyMedium: TextStyle(
        color: TopDashColors.ink,
      ),
    );
  }
}
