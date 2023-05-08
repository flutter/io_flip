// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math';

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:config_repository/config_repository.dart';
import 'package:connection_repository/connection_repository.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:highlight/languages/awk.dart';
import 'package:io_flip/match_making/match_making.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockMatchMakerRepository extends Mock implements MatchMakerRepository {}

class _MockConfigRepository extends Mock implements ConfigRepository {}

class _MockGameResource extends Mock implements GameResource {}

class _MockConnectionRepository extends Mock implements ConnectionRepository {}

class _MockRandom extends Mock implements Random {}

void main() {
  group('MatchMakingBloc', () {
    late GameResource gameResource;
    late MatchMakerRepository matchMakerRepository;
    late ConfigRepository configRepository;
    late ConnectionRepository connectionRepository;
    late Random rng;
    late StreamController<DraftMatch> watchController;
    const deckId = 'deckId';

    setUp(() {
      matchMakerRepository = _MockMatchMakerRepository();
      configRepository = _MockConfigRepository();
      connectionRepository = _MockConnectionRepository();
      configRepository = _MockConfigRepository();
      watchController = StreamController.broadcast();
      rng = _MockRandom();

      when(() => matchMakerRepository.watchMatch(any()))
          .thenAnswer((_) => watchController.stream);

      gameResource = _MockGameResource();

      when(() => configRepository.getMatchWaitTimeLimit())
          .thenAnswer((_) async => 0);
      when(() => configRepository.getPrivateMatchTimeLimit())
          .thenAnswer((_) async => 0);

      when(() => connectionRepository.messages).thenAnswer(
        (_) => Stream.fromIterable([
          WebSocketMessage.matchJoined(
            matchId: '',
            isHost: false,
          ),
        ]),
      );

      when(() => configRepository.getCPUAutoMatchPercentage())
          .thenAnswer((_) async => 0);

      when(() => rng.nextDouble()).thenReturn(1);
    });

    test('can be instantiated', () {
      expect(
        MatchMakingBloc(
          matchMakerRepository: _MockMatchMakerRepository(),
          configRepository: configRepository,
          connectionRepository: connectionRepository,
          gameResource: gameResource,
          deckId: deckId,
        ),
        isNotNull,
      );
    });

    test('has the correct initial state', () {
      expect(
        MatchMakingBloc(
          matchMakerRepository: _MockMatchMakerRepository(),
          configRepository: configRepository,
          connectionRepository: connectionRepository,
          gameResource: gameResource,
          deckId: deckId,
        ).state,
        equals(MatchMakingState.initial()),
      );
    });

    blocTest<MatchMakingBloc, MatchMakingState>(
      'can find a match as a guest',
      build: () => MatchMakingBloc(
        matchMakerRepository: matchMakerRepository,
        configRepository: configRepository,
        connectionRepository: connectionRepository,
        gameResource: gameResource,
        deckId: deckId,
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
        configRepository: configRepository,
        connectionRepository: connectionRepository,
        gameResource: gameResource,
        deckId: deckId,
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
        configRepository: configRepository,
        connectionRepository: connectionRepository,
        gameResource: gameResource,
        deckId: deckId,
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
        configRepository: configRepository,
        connectionRepository: connectionRepository,
        gameResource: gameResource,
        deckId: deckId,
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

    test('directly connects to a CPU match when chances force the player '
      'to one', () {
      fakeAsync((async) {
        when(() => rng.nextDouble()).thenReturn(.8);
        when(() => configRepository.getCPUAutoMatchPercentage())
            .thenAnswer((_) async => .9);

        when(() => matchMakerRepository.findMatch(deckId, forcedCpu: true)).thenAnswer(
          (_) async => DraftMatch(
            id: '',
            host: deckId,
            guest: reservedKey,
          ),
        );
        when(() => gameResource.connectToCpuMatch(matchId: ''))
            .thenAnswer((_) async {});

        final bloc = MatchMakingBloc(
          matchMakerRepository: matchMakerRepository,
          configRepository: configRepository,
          connectionRepository: connectionRepository,
          gameResource: gameResource,
          deckId: deckId,
          rng: rng,
          hostWaitTime: const Duration(milliseconds: 600),
        )..add(MatchRequested());

        async.elapse(const Duration(milliseconds: 200));

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
          configRepository: configRepository,
          connectionRepository: connectionRepository,
          gameResource: gameResource,
          deckId: deckId,
          hostWaitTime: const Duration(milliseconds: 200),
        )..add(MatchRequested());

        async.elapse(Duration(seconds: 5));
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
          configRepository: configRepository,
          connectionRepository: connectionRepository,
          gameResource: gameResource,
          deckId: deckId,
          hostWaitTime: const Duration(milliseconds: 200),
        )..add(MatchRequested());

        async.elapse(Duration(seconds: 5));
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
          configRepository: configRepository,
          connectionRepository: connectionRepository,
          gameResource: gameResource,
          deckId: deckId,
          hostWaitTime: const Duration(milliseconds: 200),
        )..add(PrivateMatchRequested());

        async.elapse(Duration(seconds: 122));
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
        configRepository: configRepository,
        connectionRepository: connectionRepository,
        gameResource: gameResource,
        deckId: deckId,
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
        configRepository: configRepository,
        connectionRepository: connectionRepository,
        gameResource: gameResource,
        deckId: deckId,
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
        configRepository: configRepository,
        connectionRepository: connectionRepository,
        gameResource: gameResource,
        deckId: deckId,
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
        configRepository: configRepository,
        connectionRepository: connectionRepository,
        gameResource: gameResource,
        deckId: deckId,
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
