import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

void main() {
  group('TopDashTheme', () {
    group('themeData', () {
      test('uses material 3', () {
        expect(TopDashTheme.themeData.useMaterial3, isTrue);
      });

      test('background color is TopDashColors.backgroundMain', () {
        expect(
          TopDashTheme.themeData.colorScheme.background,
          TopDashColors.seedWhite,
        );
      });

      test('uses mobile text theme on android', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        expect(
          TopDashTheme.themeData.textTheme.displayLarge?.fontSize,
          equals(TopDashTextStyles.mobile.textTheme.displayLarge?.fontSize),
        );
        debugDefaultTargetPlatformOverride = null;
      });

      test('uses mobile text theme on ios', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        expect(
          TopDashTheme.themeData.textTheme.displayLarge?.fontSize,
          equals(TopDashTextStyles.mobile.textTheme.displayLarge?.fontSize),
        );
        debugDefaultTargetPlatformOverride = null;
      });

      test('uses desktop text theme on macOS', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
        expect(
          TopDashTheme.themeData.textTheme.displayLarge?.fontSize,
          equals(TopDashTextStyles.desktop.textTheme.displayLarge?.fontSize),
        );
        debugDefaultTargetPlatformOverride = null;
      });

      test('uses desktop text theme on windows', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.windows;
        expect(
          TopDashTheme.themeData.textTheme.displayLarge?.fontSize,
          equals(TopDashTextStyles.desktop.textTheme.displayLarge?.fontSize),
        );
        debugDefaultTargetPlatformOverride = null;
      });

      test('uses desktop text theme on linux', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.linux;
        expect(
          TopDashTheme.themeData.textTheme.displayLarge?.fontSize,
          equals(TopDashTextStyles.desktop.textTheme.displayLarge?.fontSize),
        );
        debugDefaultTargetPlatformOverride = null;
      });
    });
  });
}
