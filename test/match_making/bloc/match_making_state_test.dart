// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip/match_making/match_making.dart';
import 'package:match_maker_repository/match_maker_repository.dart';

void main() {
  group('MatchMakingState', () {
    test('can be instantiated', () {
      expect(
        MatchMakingState(
          status: MatchMakingStatus.initial,
          match: DraftMatch(
            id: '',
            host: '',
          ),
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
          match: DraftMatch(
            id: '',
            host: '',
          ),
        ),
        equals(
          MatchMakingState(
            status: MatchMakingStatus.initial,
            match: DraftMatch(
              id: '',
              host: '',
            ),
          ),
        ),
      );

      expect(
        MatchMakingState(
          status: MatchMakingStatus.failed,
          match: DraftMatch(
            id: '',
            host: '',
          ),
        ),
        isNot(
          equals(
            MatchMakingState(
              status: MatchMakingStatus.initial,
              match: DraftMatch(
                id: '',
                host: '',
              ),
            ),
          ),
        ),
      );

      expect(
        MatchMakingState(
          status: MatchMakingStatus.initial,
          match: DraftMatch(
            id: '1',
            host: '',
          ),
        ),
        isNot(
          equals(
            MatchMakingState(
              status: MatchMakingStatus.initial,
              match: DraftMatch(
                id: '',
                host: '',
              ),
            ),
          ),
        ),
      );
    });

    test('copyWith returns new instance with the new value', () {
      expect(
        MatchMakingState(
          status: MatchMakingStatus.initial,
          match: DraftMatch(
            id: '',
            host: '',
          ),
        ).copyWith(status: MatchMakingStatus.failed),
        equals(
          MatchMakingState(
            status: MatchMakingStatus.failed,
            match: DraftMatch(
              id: '',
              host: '',
            ),
          ),
        ),
      );

      expect(
        MatchMakingState(
          status: MatchMakingStatus.initial,
          match: DraftMatch(
            id: '',
            host: '',
          ),
        ).copyWith(
          match: DraftMatch(
            id: '1',
            host: '',
          ),
        ),
        equals(
          MatchMakingState(
            status: MatchMakingStatus.initial,
            match: DraftMatch(
              id: '1',
              host: '',
            ),
          ),
        ),
      );
    });
  });
}
