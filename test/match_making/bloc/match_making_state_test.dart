// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:top_dash/match_making/match_making.dart';

void main() {
  group('MatchMakingState', () {
    late Timestamp now;

    setUp(() {
      now = Timestamp.now();
    });

    test('can be instantiated', () {
      expect(
        MatchMakingState(
          status: MatchMakingStatus.initial,
          match: Match(id: '', host: '', lastPing: now),
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
          match: Match(id: '', host: '', lastPing: now),
        ),
        equals(
          MatchMakingState(
            status: MatchMakingStatus.initial,
            match: Match(id: '', host: '', lastPing: now),
          ),
        ),
      );

      expect(
        MatchMakingState(
          status: MatchMakingStatus.failed,
          match: Match(id: '', host: '', lastPing: now),
        ),
        isNot(
          equals(
            MatchMakingState(
              status: MatchMakingStatus.initial,
              match: Match(id: '', host: '', lastPing: now),
            ),
          ),
        ),
      );

      expect(
        MatchMakingState(
          status: MatchMakingStatus.initial,
          match: Match(id: '1', host: '', lastPing: now),
        ),
        isNot(
          equals(
            MatchMakingState(
              status: MatchMakingStatus.initial,
              match: Match(id: '', host: '', lastPing: now),
            ),
          ),
        ),
      );
    });

    test('copyWith returns new instance with the new value', () {
      expect(
        MatchMakingState(
          status: MatchMakingStatus.initial,
          match: Match(id: '', host: '', lastPing: now),
        ).copyWith(status: MatchMakingStatus.failed),
        equals(
          MatchMakingState(
            status: MatchMakingStatus.failed,
            match: Match(id: '', host: '', lastPing: now),
          ),
        ),
      );

      expect(
        MatchMakingState(
          status: MatchMakingStatus.initial,
          match: Match(id: '', host: '', lastPing: now),
        ).copyWith(match: Match(id: '1', host: '', lastPing: now)),
        equals(
          MatchMakingState(
            status: MatchMakingStatus.initial,
            match: Match(id: '1', host: '', lastPing: now),
          ),
        ),
      );
    });
  });
}
