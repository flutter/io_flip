// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/draft/draft.dart';

void main() {
  group('DraftEvent', () {
    test('can be instantiated', () {
      expect(
        CardRequested(),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        CardRequested(),
        equals(CardRequested()),
      );
    });
  });
}
