// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/match_making/match_making.dart';
import 'package:web_socket_client/web_socket_client.dart';

class _MockMatchMakerRepository extends Mock implements MatchMakerRepository {}

class _MockWebSocket extends Mock implements WebSocket {}

class _MockGameResource extends Mock implements GameResource {}

void main() {
  group('MatchMakingBloc', () {
    late GameResource gameResource;
    late MatchMakerRepository matchMakerRepository;
    late WebSocket webSocket;
    late StreamController<Match> watchController;
    const deckId = 'deckId';
    final cardIds = ['a', 'b', 'c'];

    setUp(() {
      matchMakerRepository = _MockMatchMakerRepository();
      webSocket = _MockWebSocket();
      watchController = StreamController.broadcast();
      when(() => matchMakerRepository.watchMatch(any()))
          .thenAnswer((_) => watchController.stream);

      gameResource = _MockGameResource();
      when(
        () => gameResource.createDeck(cardIds),
      ).thenAnswer((_) async => deckId);

      when(
        () => gameResource.connectToMatch(
          matchId: any(named: 'matchId'),
          isHost: any<bool>(named: 'isHost'),
        ),
      ).thenAnswer((_) async => webSocket);
    });

    test('can be instantiated', () {
      expect(
        MatchMakingBloc(
          matchMakerRepository: _MockMatchMakerRepository(),
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
        gameResource: gameResource,
        cardIds: cardIds,
        hostWaitTime: Duration.zero,
      ),
      setUp: () {
        when(() => matchMakerRepository.findMatch(deckId)).thenAnswer(
          (_) async => Match(
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
          match: Match(
            id: '',
            host: '',
            guest: deckId,
          ),
          matchConnection: webSocket,
        ),
      ],
      verify: (_) {
        verify(
          () => gameResource.connectToMatch(
            matchId: '',
            isHost: false,
          ),
        ).called(1);
      },
    );

    blocTest<MatchMakingBloc, MatchMakingState>(
      'emits a failure when an error happens',
      build: () => MatchMakingBloc(
        matchMakerRepository: matchMakerRepository,
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
        gameResource: gameResource,
        cardIds: cardIds,
      ),
      setUp: () {
        when(() => matchMakerRepository.findMatch(deckId)).thenAnswer(
          (_) async => Match(
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
          match: Match(
            id: '',
            host: deckId,
          ),
        ),
      ],
      verify: (_) {
        verify(
          () => gameResource.connectToMatch(
            matchId: '',
            isHost: true,
          ),
        ).called(1);
      },
    );

    test('completes the match when is host and a guest joins', () async {
      when(() => matchMakerRepository.findMatch(deckId)).thenAnswer(
        (_) async => Match(
          id: '',
          host: deckId,
        ),
      );

      final bloc = MatchMakingBloc(
        matchMakerRepository: matchMakerRepository,
        gameResource: gameResource,
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
            ),
          ),
        ),
      );

      watchController.add(
        Match(
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
            match: Match(
              id: '',
              host: deckId,
              guest: '',
            ),
            isHost: true,
            matchConnection: webSocket,
          ),
        ),
      );
    });

    test('emits timeout when guest never joins host', () async {
      fakeAsync((async) {
        when(() => matchMakerRepository.findMatch(deckId)).thenAnswer(
          (_) async => Match(
            id: '',
            host: deckId,
          ),
        );
        when(() => gameResource.connectToCpuMatch(matchId: ''))
            .thenThrow(Exception());

        final bloc = MatchMakingBloc(
          matchMakerRepository: matchMakerRepository,
          gameResource: gameResource,
          cardIds: cardIds,
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
        gameResource: gameResource,
        cardIds: cardIds,
      ),
      setUp: () {
        when(() => matchMakerRepository.createPrivateMatch(deckId)).thenAnswer(
          (_) async => Match(
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
          match: Match(
            id: '',
            host: deckId,
          ),
        ),
      ],
      verify: (_) {
        verify(
          () => gameResource.connectToMatch(
            matchId: '',
            isHost: true,
          ),
        ).called(1);
      },
    );

    blocTest<MatchMakingBloc, MatchMakingState>(
      'emits failed when a private match is requested gives an error',
      build: () => MatchMakingBloc(
        matchMakerRepository: matchMakerRepository,
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
          (_) async => Match(
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
          match: Match(
            id: '',
            guest: deckId,
            host: 'hostId',
          ),
        ),
      ],
      verify: (_) {
        verify(
          () => gameResource.connectToMatch(
            matchId: '',
            isHost: false,
          ),
        ).called(1);
      },
    );

    blocTest<MatchMakingBloc, MatchMakingState>(
      'emits failed when joining a private match gives an error',
      build: () => MatchMakingBloc(
        matchMakerRepository: matchMakerRepository,
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
