import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

/// {@template io_flip_theme}
/// IO FLIP theme.
/// {@endtemplate}
class TopDashTheme {
  /// [ThemeData] for IO FLIP.
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
      bottomNavigationBarTheme: _bottomNavigationBarTheme,
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
    const yellow = TopDashColors.seedYellow;
    const grey = TopDashColors.seedGrey50;

    return const TabBarTheme(
      labelColor: yellow,
      indicatorColor: yellow,
      unselectedLabelColor: grey,
      dividerColor: grey,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: yellow),
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

  static BottomNavigationBarThemeData get _bottomNavigationBarTheme {
    return const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
    );
  }
}
