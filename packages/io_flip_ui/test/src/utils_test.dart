// ignore_for_file: prefer_const_constructors

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:mocktail/mocktail.dart';

class _MockDeviceInfoPlugin extends Mock implements DeviceInfoPlugin {}

class _MockWebBrowserInfo extends Mock implements WebBrowserInfo {}

void main() {
  group('platformAwareAsset', () {
    test('returns desktop by default', () {
      final result = platformAwareAsset(
        desktop: 'desktop',
        mobile: 'mobile',
        isWeb: false,
      );

      expect(result, equals('desktop'));
    });

    test('returns mobile when web and is iOS', () {
      final result = platformAwareAsset(
        desktop: 'desktop',
        mobile: 'mobile',
        isWeb: true,
        overrideDefaultTargetPlatform: TargetPlatform.iOS,
      );

      expect(result, 'mobile');
    });

    test('returns mobile when web and is Android', () {
      final result = platformAwareAsset(
        desktop: 'desktop',
        mobile: 'mobile',
        isWeb: true,
        overrideDefaultTargetPlatform: TargetPlatform.android,
      );

      expect(result, 'mobile');
    });
  });

  group('deviceInfoAwareAsset', () {
    late DeviceInfoPlugin deviceInfoPlugin;
    late WebBrowserInfo webBrowserInfo;

    const safariUA =
        'Mozilla/5.0 (iPhone; CPU iPhone OS 13_5_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1.1 Mobile/15E148 Safari/604.1';

    const androidSamsungUA =
        'Mozilla/5.0 (Linux; Android 12; SM-S906N Build/QP1A.190711.020; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/80.0.3987.119 Mobile Safari/537.36';

    const androidPixelUA =
        'Mozilla/5.0 (Linux; Android 13; Pixel 6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Mobile Safari/537.36';

    setUp(() {
      deviceInfoPlugin = _MockDeviceInfoPlugin();
      webBrowserInfo = _MockWebBrowserInfo();

      when(() => deviceInfoPlugin.webBrowserInfo)
          .thenAnswer((_) async => webBrowserInfo);

      when(() => webBrowserInfo.userAgent).thenReturn(androidSamsungUA);
    });

    test('return the asset when the predicate is true', () async {
      final result = await deviceInfoAwareAsset(
        predicate: (_) => true,
        asset: () => 'A',
        orElse: () => 'B',
        overrideDeviceInfoPlugin: deviceInfoPlugin,
        overrideDefaultTargetPlatform: TargetPlatform.android,
      );

      expect(result, equals('A'));
    });

    test(
      'return the asset when the predicate is true and platform default',
      () async {
        final result = await deviceInfoAwareAsset(
          predicate: (_) => true,
          asset: () => 'A',
          orElse: () => 'B',
          overrideDeviceInfoPlugin: deviceInfoPlugin,
        );

        expect(result, equals('A'));
      },
    );

    test(
      'return orElse when the predicate is true and platform default',
      () async {
        final result = await deviceInfoAwareAsset(
          predicate: (_) => true,
          asset: () => 'A',
          orElse: () => 'B',
          overrideDefaultTargetPlatform: TargetPlatform.macOS,
        );

        expect(result, equals('B'));
      },
    );

    test('return the orElse when the predicate is false', () async {
      final result = await deviceInfoAwareAsset(
        predicate: (_) => false,
        asset: () => 'A',
        orElse: () => 'B',
        overrideDeviceInfoPlugin: deviceInfoPlugin,
        overrideDefaultTargetPlatform: TargetPlatform.android,
      );

      expect(result, equals('B'));
    });

    test('return the orElse when the parsing of the UA fails', () async {
      when(() => webBrowserInfo.userAgent).thenReturn('invalid');
      final result = await deviceInfoAwareAsset(
        predicate: (_) => true,
        asset: () => 'A',
        orElse: () => 'B',
        overrideDeviceInfoPlugin: deviceInfoPlugin,
        overrideDefaultTargetPlatform: TargetPlatform.android,
      );

      expect(result, equals('B'));
    });

    test('return the orElse when is not mobile', () async {
      final result = await deviceInfoAwareAsset(
        predicate: (_) => true,
        asset: () => 'A',
        orElse: () => 'B',
        overrideDeviceInfoPlugin: deviceInfoPlugin,
        overrideDefaultTargetPlatform: TargetPlatform.linux,
      );

      expect(result, equals('B'));
    });

    test('parses a samsung android UA', () async {
      final result = await deviceInfoAwareAsset(
        predicate: (info) => info.osVersion == 12,
        asset: () => 'A',
        orElse: () => 'B',
        overrideDeviceInfoPlugin: deviceInfoPlugin,
        overrideDefaultTargetPlatform: TargetPlatform.android,
      );

      expect(result, equals('A'));
    });

    test('parses a pixel android UA', () async {
      when(() => webBrowserInfo.userAgent).thenReturn(androidPixelUA);
      final result = await deviceInfoAwareAsset(
        predicate: (info) => info.osVersion == 13,
        asset: () => 'A',
        orElse: () => 'B',
        overrideDeviceInfoPlugin: deviceInfoPlugin,
        overrideDefaultTargetPlatform: TargetPlatform.android,
      );

      expect(result, equals('A'));
    });

    test('parses an android UA', () async {
      when(() => webBrowserInfo.userAgent).thenReturn(safariUA);
      final result = await deviceInfoAwareAsset(
        predicate: (info) => info.osVersion == 13,
        asset: () => 'A',
        orElse: () => 'B',
        overrideDeviceInfoPlugin: deviceInfoPlugin,
        overrideDefaultTargetPlatform: TargetPlatform.iOS,
      );

      expect(result, equals('A'));
    });

    group('DeviceInfo', () {
      test('can be instantiated', () {
        expect(
          DeviceInfo(osVersion: 1, platform: TargetPlatform.android),
          isNotNull,
        );
      });

      test('supports equality', () {
        expect(
          DeviceInfo(osVersion: 1, platform: TargetPlatform.android),
          equals(
            DeviceInfo(osVersion: 1, platform: TargetPlatform.android),
          ),
        );

        expect(
          DeviceInfo(osVersion: 1, platform: TargetPlatform.android),
          isNot(
            equals(
              DeviceInfo(osVersion: 2, platform: TargetPlatform.android),
            ),
          ),
        );

        expect(
          DeviceInfo(osVersion: 1, platform: TargetPlatform.android),
          isNot(
            equals(
              DeviceInfo(osVersion: 1, platform: TargetPlatform.iOS),
            ),
          ),
        );
      });
    });

    group('isOlderAndroid', () {
      test('isTrue when version is lower than 11', () {
        expect(
          isOlderAndroid(
            DeviceInfo(osVersion: 10, platform: TargetPlatform.android),
          ),
          isTrue,
        );
      });

      test('isTrue when version is 11', () {
        expect(
          isOlderAndroid(
            DeviceInfo(osVersion: 11, platform: TargetPlatform.android),
          ),
          isTrue,
        );
      });

      test('isFalse when version is bigger than 11', () {
        expect(
          isOlderAndroid(
            DeviceInfo(osVersion: 12, platform: TargetPlatform.android),
          ),
          isFalse,
        );
      });

      test('isFalse when version is not android', () {
        expect(
          isOlderAndroid(
            DeviceInfo(osVersion: 11, platform: TargetPlatform.iOS),
          ),
          isFalse,
        );
      });
    });
    group('isAndroid', () {
      test('isTrue when is android', () {
        expect(
          isAndroid(
            DeviceInfo(osVersion: 10, platform: TargetPlatform.android),
          ),
          isTrue,
        );
      });

      test('isFalse when version is not android', () {
        expect(
          isAndroid(
            DeviceInfo(osVersion: 11, platform: TargetPlatform.iOS),
          ),
          isFalse,
        );
      });
    });
  });
}
