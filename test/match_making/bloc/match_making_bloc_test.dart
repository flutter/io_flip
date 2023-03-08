// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_client/game_client.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/match_making/match_making.dart';

class _MockMatchMakerRepository extends Mock implements MatchMakerRepository {}

class _MockGameClient extends Mock implements GameClient {}

void main() {
  group('MatchMakingBloc', () {
    late GameClient gameClient;
    late MatchMakerRepository matchMakerRepository;
    late StreamController<Match> watchController;
    const deckId = 'deckId';
    final cardIds = ['a', 'b', 'c'];
    late Timestamp timestamp;

    setUp(() {
      matchMakerRepository = _MockMatchMakerRepository();
      watchController = StreamController.broadcast();
      when(() => matchMakerRepository.watchMatch(any()))
          .thenAnswer((_) => watchController.stream);

      timestamp = Timestamp.now();

      gameClient = _MockGameClient();
      when(() => gameClient.createDeck(any())).thenAnswer((_) async => deckId);
    });

    test('can be instantiated', () {
      expect(
        MatchMakingBloc(
          matchMakerRepository: _MockMatchMakerRepository(),
          gameClient: gameClient,
          cardIds: cardIds,
        ),
        isNotNull,
      );
    });

    test('has the correct initial state', () {
      expect(
        MatchMakingBloc(
          matchMakerRepository: _MockMatchMakerRepository(),
          gameClient: gameClient,
          cardIds: cardIds,
        ).state,
        equals(MatchMakingState.initial()),
      );
    });

    blocTest<MatchMakingBloc, MatchMakingState>(
      'can find a match as a guest',
      build: () => MatchMakingBloc(
        matchMakerRepository: matchMakerRepository,
        gameClient: gameClient,
        cardIds: cardIds,
        hostWaitTime: Duration.zero,
      ),
      setUp: () {
        when(() => matchMakerRepository.findMatch(deckId)).thenAnswer(
          (_) async => Match(
            id: '',
            host: '',
            guest: deckId,
            hostPing: timestamp,
            guestPing: timestamp,
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
            hostPing: timestamp,
            guestPing: timestamp,
          ),
        ),
      ],
    );

    blocTest<MatchMakingBloc, MatchMakingState>(
      'emits a failure when an error happens',
      build: () => MatchMakingBloc(
        matchMakerRepository: matchMakerRepository,
        gameClient: gameClient,
        cardIds: cardIds,
        hostWaitTime: Duration.zero,
      ),
      setUp: () {
        when(() => matchMakerRepository.findMatch(deckId)).thenThrow(
          Exception('Error'),
        );
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
        matchMakerRepository: matchMakerRepository,
        gameClient: gameClient,
        cardIds: cardIds,
      ),
      setUp: () {
        when(() => matchMakerRepository.findMatch(deckId)).thenAnswer(
          (_) async => Match(
            id: '',
            host: deckId,
            hostPing: timestamp,
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
            hostPing: timestamp,
          ),
        ),
      ],
    );

    test('completes the match when is host and a guest joins', () async {
      when(() => matchMakerRepository.findMatch(deckId)).thenAnswer(
        (_) async => Match(
          id: '',
          host: deckId,
          hostPing: timestamp,
          guestPing: timestamp,
        ),
      );

      final bloc = MatchMakingBloc(
        matchMakerRepository: matchMakerRepository,
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
              hostPing: timestamp,
              guestPing: timestamp,
            ),
          ),
        ),
      );

      watchController.add(
        Match(
          id: '',
          host: deckId,
          guest: '',
          hostPing: timestamp,
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
              hostPing: timestamp,
            ),
            isHost: true,
          ),
        ),
      );
    });

    test('tries again when the guest wait times out', () async {
      when(() => matchMakerRepository.findMatch(deckId)).thenAnswer(
        (_) async => Match(
          id: '',
          host: deckId,
          hostPing: timestamp,
        ),
      );

      final bloc = MatchMakingBloc(
        matchMakerRepository: matchMakerRepository,
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
              hostPing: timestamp,
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
          hostPing: timestamp,
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
              hostPing: timestamp,
            ),
            isHost: true,
          ),
        ),
      );
    });
  });
}
