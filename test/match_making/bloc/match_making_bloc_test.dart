// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_client/game_client.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/match_making/match_making.dart';

class _MockMatchMakerRepository extends Mock implements MatchMakerRepository {}

class _MockGameClient extends Mock implements GameClient {}

class _MockUser extends Mock implements User {
  @override
  String get id => 'mock-userId';
}

void main() {
  group('MatchMakingBloc', () {
    late GameClient gameClient;
    late MatchMakerRepository matchMakerRepository;
    late User user;
    late StreamController<Match> watchController;
    const deckId = 'deckId';
    final cardIds = ['a', 'b', 'c'];
    late Timestamp timestamp;

    setUp(() {
      matchMakerRepository = _MockMatchMakerRepository();
      user = _MockUser();
      watchController = StreamController.broadcast();
      when(() => matchMakerRepository.watchMatch(any()))
          .thenAnswer((_) => watchController.stream);

      timestamp = Timestamp.now();

      gameClient = _MockGameClient();
      when(
        () => gameClient.createDeck(
          cardIds: any(named: 'cardIds'),
          userId: any(named: 'userId'),
        ),
      ).thenAnswer((_) async => deckId);
    });

    test('can be instantiated', () {
      expect(
        MatchMakingBloc(
          matchMakerRepository: _MockMatchMakerRepository(),
          gameClient: gameClient,
          cardIds: cardIds,
          user: user,
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
          user: user,
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
        user: user,
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
        user: user,
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
        user: user,
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
        user: user,
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

    test('pings host while waiting for guest to join', () async {
      when(() => matchMakerRepository.findMatch(deckId)).thenAnswer(
        (_) async => Match(
          id: '',
          host: deckId,
          hostPing: timestamp,
        ),
      );

      when(() => matchMakerRepository.pingHost(any())).thenAnswer(
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
        user: user,
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

      verify(() => matchMakerRepository.pingHost(any())).called(1);

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

      await Future<void>.delayed(Duration(milliseconds: 200));

      verifyNever(() => matchMakerRepository.pingHost(any()));
    });

    test('emits timeout when guest never joins host', () async {
      fakeAsync((async) {
        when(() => matchMakerRepository.findMatch(deckId)).thenAnswer(
          (_) async => Match(
            id: '',
            host: deckId,
            hostPing: timestamp,
          ),
        );

        when(() => matchMakerRepository.pingHost(any())).thenAnswer(
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
          user: user,
          hostWaitTime: const Duration(milliseconds: 200),
        )..add(MatchRequested());

        async.elapse(const Duration(seconds: 30));

        expect(
          bloc.state,
          equals(
            MatchMakingState(
              status: MatchMakingStatus.timeout,
              match: Match(
                id: '',
                host: deckId,
                hostPing: timestamp,
              ),
            ),
          ),
        );
      });
    });

    blocTest<MatchMakingBloc, MatchMakingState>(
      'creates a private match when requested',
      build: () => MatchMakingBloc(
        matchMakerRepository: matchMakerRepository,
        gameClient: gameClient,
        cardIds: cardIds,
        user: user,
      ),
      setUp: () {
        when(() => matchMakerRepository.createPrivateMatch(deckId)).thenAnswer(
          (_) async => Match(
            id: '',
            host: deckId,
            hostPing: timestamp,
          ),
        );
      },
      act: (bloc) => bloc.add(PrivateMatchRequested()),
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

    blocTest<MatchMakingBloc, MatchMakingState>(
      'emits failed when a private match is requested gives an error',
      build: () => MatchMakingBloc(
        matchMakerRepository: matchMakerRepository,
        gameClient: gameClient,
        cardIds: cardIds,
        user: user,
      ),
      setUp: () {
        when(() => matchMakerRepository.createPrivateMatch(deckId)).thenThrow(
          Exception('Ops'),
        );
      },
      act: (bloc) => bloc.add(PrivateMatchRequested()),
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
      'joins a private match',
      build: () => MatchMakingBloc(
        matchMakerRepository: matchMakerRepository,
        gameClient: gameClient,
        cardIds: cardIds,
        user: user,
      ),
      setUp: () {
        when(
          () => matchMakerRepository.joinPrivateMatch(
            guestId: deckId,
            inviteCode: 'invite',
          ),
        ).thenAnswer(
          (_) async => Match(
            id: '',
            guest: deckId,
            host: 'hostId',
            hostPing: timestamp,
          ),
        );
      },
      act: (bloc) => bloc.add(GuestPrivateMatchRequested('invite')),
      expect: () => [
        MatchMakingState(
          status: MatchMakingStatus.processing,
        ),
        MatchMakingState(
          status: MatchMakingStatus.completed,
          match: Match(
            id: '',
            guest: deckId,
            host: 'hostId',
            hostPing: timestamp,
          ),
        ),
      ],
    );

    blocTest<MatchMakingBloc, MatchMakingState>(
      'emits failed when joining a private match gives an error',
      build: () => MatchMakingBloc(
        matchMakerRepository: matchMakerRepository,
        gameClient: gameClient,
        cardIds: cardIds,
        user: user,
      ),
      setUp: () {
        when(
          () => matchMakerRepository.joinPrivateMatch(
            guestId: deckId,
            inviteCode: 'invite',
          ),
        ).thenThrow(Exception('Ops'));
      },
      act: (bloc) => bloc.add(GuestPrivateMatchRequested('invite')),
      expect: () => [
        MatchMakingState(
          status: MatchMakingStatus.processing,
        ),
        MatchMakingState(
          status: MatchMakingStatus.failed,
        ),
      ],
    );
  });
}
