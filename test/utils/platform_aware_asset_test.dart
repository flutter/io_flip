import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/utils/utils.dart';

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
}
