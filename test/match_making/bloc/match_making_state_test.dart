// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/match_making/match_making.dart';

void main() {
  group('MatchMakingState', () {
    test('can be instantiated', () {
      expect(
        MatchMakingState(
          status: MatchMakingStatus.initial,
          match: Match(id: '', host: ''),
        ),
        isNotNull,
      );
    });

    test('has the correct initial value', () {
      expect(
        MatchMakingState.initial(),
        equals(
          MatchMakingState(
            status: MatchMakingStatus.initial,
          ),
        ),
      );
    });

    test('supports equality', () {
      expect(
        MatchMakingState(
          status: MatchMakingStatus.initial,
          match: Match(id: '', host: ''),
        ),
        equals(
          MatchMakingState(
            status: MatchMakingStatus.initial,
            match: Match(id: '', host: ''),
          ),
        ),
      );

      expect(
        MatchMakingState(
          status: MatchMakingStatus.failed,
          match: Match(id: '', host: ''),
        ),
        isNot(
          equals(
            MatchMakingState(
              status: MatchMakingStatus.initial,
              match: Match(id: '', host: ''),
            ),
          ),
        ),
      );

      expect(
        MatchMakingState(
          status: MatchMakingStatus.initial,
          match: Match(id: '1', host: ''),
        ),
        isNot(
          equals(
            MatchMakingState(
              status: MatchMakingStatus.initial,
              match: Match(id: '', host: ''),
            ),
          ),
        ),
      );
    });

    test('copyWith returns new instance with the new value', () {
      expect(
        MatchMakingState(
          status: MatchMakingStatus.initial,
          match: Match(id: '', host: ''),
        ).copyWith(status: MatchMakingStatus.failed),
        equals(
          MatchMakingState(
            status: MatchMakingStatus.failed,
            match: Match(id: '', host: ''),
          ),
        ),
      );

      expect(
        MatchMakingState(
          status: MatchMakingStatus.initial,
          match: Match(id: '', host: ''),
        ).copyWith(match: Match(id: '1', host: '')),
        equals(
          MatchMakingState(
            status: MatchMakingStatus.initial,
            match: Match(id: '1', host: ''),
          ),
        ),
      );
    });
  });
}
