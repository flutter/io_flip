// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_client/game_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/match_making/match_making.dart';

class _MockMatchMaker extends Mock implements MatchMaker {}

class _MockGameClient extends Mock implements GameClient {}

void main() {
  group('MatchMakingBloc', () {
    late GameClient gameClient;
    late MatchMaker matchMaker;
    late StreamController<Match> watchController;
    const deckId = 'deckId';
    final cardIds = ['a', 'b', 'c'];
    late Timestamp timestamp;

    setUp(() {
      matchMaker = _MockMatchMaker();
      watchController = StreamController.broadcast();
      when(() => matchMaker.watchMatch(any()))
          .thenAnswer((_) => watchController.stream);
      when(() => matchMaker.pingMatch(any())).thenAnswer((_) async {});

      timestamp = Timestamp.now();

      gameClient = _MockGameClient();
      when(() => gameClient.createDeck(any())).thenAnswer((_) async => deckId);
    });

    test('can be instantiated', () {
      expect(
        MatchMakingBloc(
          matchMaker: _MockMatchMaker(),
          gameClient: gameClient,
          cardIds: cardIds,
        ),
        isNotNull,
      );
    });

    test('has the correct initial state', () {
      expect(
        MatchMakingBloc(
          matchMaker: _MockMatchMaker(),
          gameClient: gameClient,
          cardIds: cardIds,
        ).state,
        equals(MatchMakingState.initial()),
      );
    });

    blocTest<MatchMakingBloc, MatchMakingState>(
      'can find a match as a guest',
      build: () => MatchMakingBloc(
        matchMaker: matchMaker,
        gameClient: gameClient,
        cardIds: cardIds,
        hostWaitTime: Duration.zero,
      ),
      setUp: () {
        when(() => matchMaker.findMatch(deckId)).thenAnswer(
          (_) async => Match(
            id: '',
            host: '',
            guest: deckId,
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
            guest: deckId,
            lastPing: timestamp,
          ),
        ),
      ],
    );

    blocTest<MatchMakingBloc, MatchMakingState>(
      'emits a failure when an error happens',
      build: () => MatchMakingBloc(
        matchMaker: matchMaker,
        gameClient: gameClient,
        cardIds: cardIds,
        hostWaitTime: Duration.zero,
      ),
      setUp: () {
        when(() => matchMaker.findMatch(deckId)).thenThrow(Exception('Error'));
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
        gameClient: gameClient,
        cardIds: cardIds,
      ),
      setUp: () {
        when(() => matchMaker.findMatch(deckId)).thenAnswer(
          (_) async => Match(
            id: '',
            host: deckId,
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
            host: deckId,
            lastPing: timestamp,
          ),
        ),
      ],
    );

    test('completes the match when is host and a guest joins', () async {
      when(() => matchMaker.findMatch(deckId)).thenAnswer(
        (_) async => Match(
          id: '',
          host: deckId,
          lastPing: timestamp,
        ),
      );

      final bloc = MatchMakingBloc(
        matchMaker: matchMaker,
        gameClient: gameClient,
        cardIds: cardIds,
      )..add(MatchRequested());

      expect(
        await bloc.stream.take(2).last,
        equals(
          MatchMakingState(
            status: MatchMakingStatus.processing,
            match: Match(
              id: '',
              host: deckId,
              lastPing: timestamp,
            ),
          ),
        ),
      );

      watchController.add(
        Match(
          id: '',
          host: deckId,
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
              host: deckId,
              guest: '',
              lastPing: timestamp,
            ),
          ),
        ),
      );
    });

    test('periodically pings the created match until a guest joins', () async {
      fakeAsync((async) {
        when(() => matchMaker.findMatch(deckId)).thenAnswer(
          (_) async => Match(
            id: 'id',
            host: deckId,
            lastPing: timestamp,
          ),
        );

        MatchMakingBloc(
          matchMaker: matchMaker,
          gameClient: gameClient,
          cardIds: cardIds,
          pingInterval: Duration(milliseconds: 10),
          hostWaitTime: Duration(milliseconds: 100),
        ).add(MatchRequested());

        async.elapse(Duration(milliseconds: 55));

        verify(() => matchMaker.pingMatch('id')).called(5);

        watchController.add(
          Match(
            id: 'id',
            host: deckId,
            guest: '',
            lastPing: timestamp,
          ),
        );
        async.elapse(Duration(milliseconds: 30));
        verifyNever(() => matchMaker.pingMatch('id'));
      });
    });

    test('tries again when the guest wait times out', () async {
      when(() => matchMaker.findMatch(deckId)).thenAnswer(
        (_) async => Match(
          id: '',
          host: deckId,
          lastPing: timestamp,
        ),
      );

      final bloc = MatchMakingBloc(
        matchMaker: matchMaker,
        gameClient: gameClient,
        cardIds: cardIds,
        hostWaitTime: const Duration(milliseconds: 200),
      )..add(MatchRequested());

      expect(
        await bloc.stream.take(2).last,
        equals(
          MatchMakingState(
            status: MatchMakingStatus.processing,
            match: Match(
              id: '',
              host: deckId,
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
          host: deckId,
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
              host: deckId,
              guest: '',
              lastPing: timestamp,
            ),
          ),
        ),
      );
    });
  });
}
