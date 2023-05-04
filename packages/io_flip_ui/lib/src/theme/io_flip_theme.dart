import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

/// {@template io_flip_theme}
/// IO FLIP theme.
/// {@endtemplate}
class IoFlipTheme {
  /// [ThemeData] for IO FLIP.
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _colorScheme,
      textTheme: _textTheme.apply(
        bodyColor: IoFlipColors.seedWhite,
        displayColor: IoFlipColors.seedWhite,
        decorationColor: IoFlipColors.seedWhite,
      ),
      tabBarTheme: _tabBarTheme,
      dialogTheme: _dialogTheme,
      bottomNavigationBarTheme: _bottomNavigationBarTheme,
    );
  }

  static ColorScheme get _colorScheme {
    return ColorScheme.fromSeed(
      seedColor: IoFlipColors.seedBlue,
      background: IoFlipColors.seedBlack,
    );
  }

  static TextTheme get _textTheme {
    final isMobile = defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;

    return isMobile
        ? IoFlipTextStyles.mobile.textTheme
        : IoFlipTextStyles.desktop.textTheme;
  }

  static TabBarTheme get _tabBarTheme {
    const yellow = IoFlipColors.seedYellow;
    const grey = IoFlipColors.seedGrey50;

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
    const black = IoFlipColors.seedBlack;

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
