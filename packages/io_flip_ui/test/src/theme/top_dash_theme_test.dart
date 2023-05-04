import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

void main() {
  group('IoFlipTheme', () {
    group('themeData', () {
      test('uses material 3', () {
        expect(IoFlipTheme.themeData.useMaterial3, isTrue);
      });

      test('background color is IoFlipColors.seedBlack', () {
        expect(
          IoFlipTheme.themeData.colorScheme.background,
          IoFlipColors.seedBlack,
        );
      });

      test('uses mobile text theme on android', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        expect(
          IoFlipTheme.themeData.textTheme.displayLarge?.fontSize,
          equals(IoFlipTextStyles.mobile.textTheme.displayLarge?.fontSize),
        );
        debugDefaultTargetPlatformOverride = null;
      });

      test('uses mobile text theme on ios', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        expect(
          IoFlipTheme.themeData.textTheme.displayLarge?.fontSize,
          equals(IoFlipTextStyles.mobile.textTheme.displayLarge?.fontSize),
        );
        debugDefaultTargetPlatformOverride = null;
      });

      test('uses desktop text theme on macOS', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
        expect(
          IoFlipTheme.themeData.textTheme.displayLarge?.fontSize,
          equals(IoFlipTextStyles.desktop.textTheme.displayLarge?.fontSize),
        );
        debugDefaultTargetPlatformOverride = null;
      });

      test('uses desktop text theme on windows', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.windows;
        expect(
          IoFlipTheme.themeData.textTheme.displayLarge?.fontSize,
          equals(IoFlipTextStyles.desktop.textTheme.displayLarge?.fontSize),
        );
        debugDefaultTargetPlatformOverride = null;
      });

      test('uses desktop text theme on linux', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.linux;
        expect(
          IoFlipTheme.themeData.textTheme.displayLarge?.fontSize,
          equals(IoFlipTextStyles.desktop.textTheme.displayLarge?.fontSize),
        );
        debugDefaultTargetPlatformOverride = null;
      });
    });
  });
}
