import 'package:flutter/foundation.dart';
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
      textTheme: _textTheme.apply(
        bodyColor: TopDashColors.seedWhite,
        displayColor: TopDashColors.seedWhite,
        decorationColor: TopDashColors.seedWhite,
      ),
      tabBarTheme: _tabBarTheme,
      dialogTheme: _dialogTheme,
    );
  }

  static ColorScheme get _colorScheme {
    return ColorScheme.fromSeed(
      seedColor: TopDashColors.seedBlue,
      background: TopDashColors.seedBlack,
    );
  }

  static TextTheme get _textTheme {
    final isMobile = defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;

    return isMobile
        ? TopDashTextStyles.mobile.textTheme
        : TopDashTextStyles.desktop.textTheme;
  }

  static TabBarTheme get _tabBarTheme {
    const blue = TopDashColors.seedBlue;
    const grey = TopDashColors.seedGrey50;

    return const TabBarTheme(
      labelColor: blue,
      indicatorColor: blue,
      unselectedLabelColor: grey,
      dividerColor: grey,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: blue),
      ),
    );
  }

  static DialogTheme get _dialogTheme {
    const black = TopDashColors.seedBlack;

    return const DialogTheme(
      backgroundColor: black,
      surfaceTintColor: Colors.transparent,
    );
  }
}
