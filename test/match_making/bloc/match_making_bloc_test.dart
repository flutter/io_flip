// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/match_making/match_making.dart';

class _MockMatchMaker extends Mock implements MatchMaker {}

void main() {
  group('MatchMakingBloc', () {
    late MatchMaker matchMaker;
    late StreamController<Match> watchController;
    const playerId = 'playerId';
    late Timestamp timestamp;

    setUp(() {
      matchMaker = _MockMatchMaker();
      watchController = StreamController.broadcast();
      when(() => matchMaker.watchMatch(any()))
          .thenAnswer((_) => watchController.stream);
      timestamp = Timestamp.now();
    });

    test('can be instantiated', () {
      expect(
        MatchMakingBloc(
          matchMaker: _MockMatchMaker(),
          playerId: playerId,
        ),
        isNotNull,
      );
    });

    test('has the correct initial state', () {
      expect(
        MatchMakingBloc(
          matchMaker: _MockMatchMaker(),
          playerId: playerId,
        ).state,
        equals(MatchMakingState.initial()),
      );
    });

    blocTest<MatchMakingBloc, MatchMakingState>(
      'can find a match as a guest',
      build: () => MatchMakingBloc(
        matchMaker: matchMaker,
        playerId: playerId,
        hostWaitTime: Duration.zero,
      ),
      setUp: () {
        when(() => matchMaker.findMatch(playerId)).thenAnswer(
          (_) async => Match(
            id: '',
            host: '',
            guest: playerId,
            lastPing: timestamp,
          ),
        );
      },
      act: (bloc) => bloc.add(MatchRequested()),
      expect: () => [
        MatchMakingState(
          status: MatchMakingStatus.processing,
        ),
        MatchMakingState(
          status: MatchMakingStatus.completed,
          match: Match(
            id: '',
            host: '',
            guest: playerId,
            lastPing: timestamp,
          ),
        ),
      ],
    );

    blocTest<MatchMakingBloc, MatchMakingState>(
      'emits a failure when an error happens',
      build: () => MatchMakingBloc(
        matchMaker: matchMaker,
        playerId: playerId,
        hostWaitTime: Duration.zero,
      ),
      setUp: () {
        when(() => matchMaker.findMatch(playerId))
            .thenThrow(Exception('Error'));
      },
      act: (bloc) => bloc.add(MatchRequested()),
      expect: () => [
        MatchMakingState(
          status: MatchMakingStatus.processing,
        ),
        MatchMakingState(
          status: MatchMakingStatus.failed,
        ),
      ],
    );

    blocTest<MatchMakingBloc, MatchMakingState>(
      "creates a match when there isn't one open",
      build: () => MatchMakingBloc(
        matchMaker: matchMaker,
        playerId: playerId,
      ),
      setUp: () {
        when(() => matchMaker.findMatch(playerId)).thenAnswer(
          (_) async => Match(
            id: '',
            host: playerId,
            lastPing: timestamp,
          ),
        );
      },
      act: (bloc) => bloc.add(MatchRequested()),
      expect: () => [
        MatchMakingState(
          status: MatchMakingStatus.processing,
        ),
        MatchMakingState(
          status: MatchMakingStatus.processing,
          match: Match(
            id: '',
            host: playerId,
            lastPing: timestamp,
          ),
        ),
      ],
    );

    test('completes the match when is host and a guest joins', () async {
      when(() => matchMaker.findMatch(playerId)).thenAnswer(
        (_) async => Match(
          id: '',
          host: playerId,
          lastPing: timestamp,
        ),
      );

      final bloc = MatchMakingBloc(
        matchMaker: matchMaker,
        playerId: playerId,
      )..add(MatchRequested());

      expect(
        await bloc.stream.take(2).last,
        equals(
          MatchMakingState(
            status: MatchMakingStatus.processing,
            match: Match(
              id: '',
              host: playerId,
              lastPing: timestamp,
            ),
          ),
        ),
      );

      watchController.add(
        Match(
          id: '',
          host: playerId,
          guest: '',
          lastPing: timestamp,
        ),
      );

      expect(
        await bloc.stream.take(1).last,
        equals(
          MatchMakingState(
            status: MatchMakingStatus.completed,
            match: Match(
              id: '',
              host: playerId,
              guest: '',
              lastPing: timestamp,
            ),
          ),
        ),
      );
    });

    test('tries again when the guest wait times out', () async {
      when(() => matchMaker.findMatch(playerId)).thenAnswer(
        (_) async => Match(
          id: '',
          host: playerId,
          lastPing: timestamp,
        ),
      );

      final bloc = MatchMakingBloc(
        matchMaker: matchMaker,
        playerId: playerId,
        hostWaitTime: const Duration(milliseconds: 200),
      )..add(MatchRequested());

      expect(
        await bloc.stream.take(2).last,
        equals(
          MatchMakingState(
            status: MatchMakingStatus.processing,
            match: Match(
              id: '',
              host: playerId,
              lastPing: timestamp,
            ),
          ),
        ),
      );

      await Future<void>.delayed(Duration(milliseconds: 200));
      await Future<void>.delayed(Duration(milliseconds: 10));

      watchController.add(
        Match(
          id: '',
          host: playerId,
          guest: '',
          lastPing: timestamp,
        ),
      );

      expect(
        await bloc.stream.take(1).last,
        equals(
          MatchMakingState(
            status: MatchMakingStatus.completed,
            match: Match(
              id: '',
              host: playerId,
              guest: '',
              lastPing: timestamp,
            ),
          ),
        ),
      );
    });
  });
}
