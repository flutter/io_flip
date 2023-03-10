// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/scripts/cubit/scripts_cubit.dart';

void main() {
  group('ScriptsState', () {
    test('can be instantiated', () {
      expect(
        ScriptsState(
          status: ScriptsStateStatus.loading,
          current: 'script',
        ),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        ScriptsState(
          status: ScriptsStateStatus.loading,
          current: 'script',
        ),
        equals(
          ScriptsState(
            status: ScriptsStateStatus.loading,
            current: 'script',
          ),
        ),
      );

      expect(
        ScriptsState(
          status: ScriptsStateStatus.loading,
          current: 'script',
        ),
        isNot(
          equals(
            ScriptsState(
              status: ScriptsStateStatus.failed,
              current: 'script',
            ),
          ),
        ),
      );

      expect(
        ScriptsState(
          status: ScriptsStateStatus.loading,
          current: 'script',
        ),
        isNot(
          equals(
            ScriptsState(
              status: ScriptsStateStatus.loading,
              current: 'script 2',
            ),
          ),
        ),
      );
    });

    test('copyWith returns a new instance with the new value', () {
      expect(
        ScriptsState(
          status: ScriptsStateStatus.loading,
          current: 'script',
        ).copyWith(status: ScriptsStateStatus.loaded),
        equals(
          ScriptsState(
            status: ScriptsStateStatus.loaded,
            current: 'script',
          ),
        ),
      );
      expect(
        ScriptsState(
          status: ScriptsStateStatus.loading,
          current: 'script',
        ).copyWith(current: 'script 2'),
        equals(
          ScriptsState(
            status: ScriptsStateStatus.loading,
            current: 'script 2',
          ),
        ),
      );
    });
  });
}
