// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:connection_repository/connection_repository.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_flip/match_making/match_making.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockMatchMakerRepository extends Mock implements MatchMakerRepository {}

class _MockGameResource extends Mock implements GameResource {}

class _MockConnectionRepository extends Mock implements ConnectionRepository {}

void main() {
  group('MatchMakingBloc', () {
    late GameResource gameResource;
    late MatchMakerRepository matchMakerRepository;
    late ConnectionRepository connectionRepository;
    late StreamController<DraftMatch> watchController;
    const deckId = 'deckId';
    final cardIds = ['a', 'b', 'c'];

    setUp(() {
      matchMakerRepository = _MockMatchMakerRepository();
      connectionRepository = _MockConnectionRepository();
      watchController = StreamController.broadcast();
      when(() => matchMakerRepository.watchMatch(any()))
          .thenAnswer((_) => watchController.stream);

      gameResource = _MockGameResource();
      when(
        () => gameResource.createDeck(cardIds),
      ).thenAnswer((_) async => deckId);

      when(() => connectionRepository.messages).thenAnswer(
        (_) => Stream.fromIterable([
          WebSocketMessage.matchJoined(
            matchId: '',
            isHost: false,
          ),
        ]),
      );
    });

    test('can be instantiated', () {
      expect(
        MatchMakingBloc(
          matchMakerRepository: _MockMatchMakerRepository(),
          connectionRepository: connectionRepository,
          gameResource: gameResource,
          cardIds: cardIds,
        ),
        isNotNull,
      );
    });

    test('has the correct initial state', () {
      expect(
        MatchMakingBloc(
          matchMakerRepository: _MockMatchMakerRepository(),
          connectionRepository: connectionRepository,
          gameResource: gameResource,
          cardIds: cardIds,
        ).state,
        equals(MatchMakingState.initial()),
      );
    });

    blocTest<MatchMakingBloc, MatchMakingState>(
      'can find a match as a guest',
      build: () => MatchMakingBloc(
        matchMakerRepository: matchMakerRepository,
        connectionRepository: connectionRepository,
        gameResource: gameResource,
        cardIds: cardIds,
        hostWaitTime: Duration.zero,
      ),
      setUp: () {
        when(() => matchMakerRepository.findMatch(deckId)).thenAnswer(
          (_) async => DraftMatch(
            id: '',
            host: '',
            guest: deckId,
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
          match: DraftMatch(
            id: '',
            host: '',
            guest: deckId,
          ),
        ),
      ],
      verify: (_) {
        verify(
          () => connectionRepository.send(
            WebSocketMessage.matchJoined(
              matchId: '',
              isHost: false,
            ),
          ),
        ).called(1);
      },
    );

    blocTest<MatchMakingBloc, MatchMakingState>(
      'emits a failure when an error happens',
      build: () => MatchMakingBloc(
        matchMakerRepository: matchMakerRepository,
        connectionRepository: connectionRepository,
        gameResource: gameResource,
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
        connectionRepository: connectionRepository,
        gameResource: gameResource,
        cardIds: cardIds,
      ),
      setUp: () {
        when(() => matchMakerRepository.findMatch(deckId)).thenAnswer(
          (_) async => DraftMatch(
            id: '',
            host: deckId,
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
          match: DraftMatch(
            id: '',
            host: deckId,
          ),
        ),
      ],
      verify: (_) {
        verify(
          () => connectionRepository.send(
            WebSocketMessage.matchJoined(
              matchId: '',
              isHost: true,
            ),
          ),
        ).called(1);
      },
    );

    test('completes the match when is host and a guest joins', () async {
      when(() => matchMakerRepository.findMatch(deckId)).thenAnswer(
        (_) async => DraftMatch(
          id: '',
          host: deckId,
        ),
      );

      final bloc = MatchMakingBloc(
        matchMakerRepository: matchMakerRepository,
        connectionRepository: connectionRepository,
        gameResource: gameResource,
        cardIds: cardIds,
      )..add(MatchRequested());

      expect(
        await bloc.stream.take(2).last,
        equals(
          MatchMakingState(
            status: MatchMakingStatus.processing,
            match: DraftMatch(
              id: '',
              host: deckId,
            ),
          ),
        ),
      );

      watchController.add(
        DraftMatch(
          id: '',
          host: deckId,
          guest: '',
        ),
      );

      expect(
        await bloc.stream.take(1).last,
        equals(
          MatchMakingState(
            status: MatchMakingStatus.completed,
            match: DraftMatch(
              id: '',
              host: deckId,
              guest: '',
            ),
            isHost: true,
          ),
        ),
      );
    });

    test(
        'emits timeout when guest never joins and fails to connect to CPU game',
        () {
      fakeAsync((async) {
        when(() => matchMakerRepository.findMatch(deckId)).thenAnswer(
          (_) async => DraftMatch(
            id: '',
            host: deckId,
          ),
        );
        when(() => gameResource.connectToCpuMatch(matchId: ''))
            .thenThrow(Exception());
        final stream =
            StreamController<DraftMatch>(onCancel: () async {}).stream;
        when(() => matchMakerRepository.watchMatch(any())).thenAnswer(
          (_) => stream,
        );

        final bloc = MatchMakingBloc(
          matchMakerRepository: matchMakerRepository,
          connectionRepository: connectionRepository,
          gameResource: gameResource,
          cardIds: cardIds,
          hostWaitTime: const Duration(milliseconds: 200),
        )..add(MatchRequested());

        async.elapse(Duration(seconds: 8));
        expect(
          bloc.state,
          equals(
            MatchMakingState(
              status: MatchMakingStatus.timeout,
              match: DraftMatch(
                id: '',
                host: deckId,
              ),
            ),
          ),
        );
      });
    });

    test('creates CPU match when guest never joins host', () {
      fakeAsync((async) {
        when(() => matchMakerRepository.findMatch(deckId)).thenAnswer(
          (_) async => DraftMatch(
            id: '',
            host: deckId,
          ),
        );
        when(() => gameResource.connectToCpuMatch(matchId: ''))
            .thenAnswer((_) async {});
        final stream =
            StreamController<DraftMatch>(onCancel: () async {}).stream;
        when(() => matchMakerRepository.watchMatch(any())).thenAnswer(
          (_) => stream,
        );

        final bloc = MatchMakingBloc(
          matchMakerRepository: matchMakerRepository,
          connectionRepository: connectionRepository,
          gameResource: gameResource,
          cardIds: cardIds,
          hostWaitTime: const Duration(milliseconds: 200),
        )..add(MatchRequested());

        async.elapse(Duration(seconds: 8));
        expect(
          bloc.state,
          equals(
            MatchMakingState(
              status: MatchMakingStatus.completed,
              match: DraftMatch(id: '', host: deckId, guest: 'CPU_$deckId'),
              isHost: true,
            ),
          ),
        );
      });
    });

    test('creates CPU match when guest never joins a private match', () {
      fakeAsync((async) {
        when(() => matchMakerRepository.createPrivateMatch(deckId)).thenAnswer(
          (_) async => DraftMatch(
            id: '',
            host: deckId,
          ),
        );
        when(() => gameResource.connectToCpuMatch(matchId: ''))
            .thenAnswer((_) async {});
        final stream =
            StreamController<DraftMatch>(onCancel: () async {}).stream;
        when(() => matchMakerRepository.watchMatch(any())).thenAnswer(
          (_) => stream,
        );

        final bloc = MatchMakingBloc(
          matchMakerRepository: matchMakerRepository,
          connectionRepository: connectionRepository,
          gameResource: gameResource,
          cardIds: cardIds,
          hostWaitTime: const Duration(milliseconds: 200),
        )..add(PrivateMatchRequested());

        async.elapse(Duration(seconds: 120));
        expect(
          bloc.state,
          equals(
            MatchMakingState(
              status: MatchMakingStatus.completed,
              match: DraftMatch(id: '', host: deckId, guest: 'CPU_$deckId'),
              isHost: true,
            ),
          ),
        );
      });
    });

    blocTest<MatchMakingBloc, MatchMakingState>(
      'creates a private match when requested',
      build: () => MatchMakingBloc(
        matchMakerRepository: matchMakerRepository,
        connectionRepository: connectionRepository,
        gameResource: gameResource,
        cardIds: cardIds,
      ),
      setUp: () {
        when(() => matchMakerRepository.createPrivateMatch(deckId)).thenAnswer(
          (_) async => DraftMatch(
            id: '',
            host: deckId,
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
          match: DraftMatch(
            id: '',
            host: deckId,
          ),
        ),
      ],
      verify: (_) {
        verify(
          () => connectionRepository.send(
            WebSocketMessage.matchJoined(
              matchId: '',
              isHost: true,
            ),
          ),
        ).called(1);
      },
    );

    blocTest<MatchMakingBloc, MatchMakingState>(
      'emits failed when a private match is requested gives an error',
      build: () => MatchMakingBloc(
        matchMakerRepository: matchMakerRepository,
        connectionRepository: connectionRepository,
        gameResource: gameResource,
        cardIds: cardIds,
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
        connectionRepository: connectionRepository,
        gameResource: gameResource,
        cardIds: cardIds,
      ),
      setUp: () {
        when(
          () => matchMakerRepository.joinPrivateMatch(
            guestId: deckId,
            inviteCode: 'invite',
          ),
        ).thenAnswer(
          (_) async => DraftMatch(
            id: '',
            guest: deckId,
            host: 'hostId',
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
          match: DraftMatch(
            id: '',
            guest: deckId,
            host: 'hostId',
          ),
        ),
      ],
      verify: (_) {
        verify(
          () => connectionRepository.send(
            WebSocketMessage.matchJoined(
              matchId: '',
              isHost: false,
            ),
          ),
        ).called(1);
      },
    );

    blocTest<MatchMakingBloc, MatchMakingState>(
      'emits failed when joining a private match gives an error',
      build: () => MatchMakingBloc(
        matchMakerRepository: matchMakerRepository,
        connectionRepository: connectionRepository,
        gameResource: gameResource,
        cardIds: cardIds,
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
