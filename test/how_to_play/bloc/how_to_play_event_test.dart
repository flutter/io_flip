// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/how_to_play/how_to_play.dart';

void main() {
  group('HowToPlayEvent', () {
    group('NextPageRequested', () {
      test('can be instantiated', () {
        expect(NextPageRequested(), isNotNull);
      });

      test('supports equality', () {
        expect(NextPageRequested(), equals(NextPageRequested()));
      });
    });

    group('PreviousPageRequested', () {
      test('can be instantiated', () {
        expect(PreviousPageRequested(), isNotNull);
      });

      test('supports equality', () {
        expect(PreviousPageRequested(), equals(PreviousPageRequested()));
      });
    });
  });
}
