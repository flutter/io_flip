// ignore_for_file: prefer_const_constructors

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip/leaderboard/initials_form/initials_form.dart';
import 'package:mocktail/mocktail.dart';

class _MockLeaderboardResource extends Mock implements LeaderboardResource {}

void main() {
  group('InitialsFormBloc', () {
    late LeaderboardResource leaderboardResource;

    setUp(() {
      leaderboardResource = _MockLeaderboardResource();

      when(() => leaderboardResource.getInitialsBlacklist())
          .thenAnswer((_) async => ['WTF']);
      when(
        () => leaderboardResource.addInitialsToScoreCard(
          scoreCardId: any(named: 'scoreCardId'),
          initials: any(named: 'initials'),
        ),
      ).thenAnswer((_) async {});
    });

    blocTest<InitialsFormBloc, InitialsFormState>(
      'emits state with updated initials when changing them',
      build: () => InitialsFormBloc(
        leaderboardResource: leaderboardResource,
        scoreCardId: 'scoreCardId',
      ),
      act: (bloc) => bloc.add(InitialsChanged(index: 0, initial: 'A')),
      expect: () => <InitialsFormState>[
        InitialsFormState(initials: const ['A', '', '']),
      ],
    );

    blocTest<InitialsFormBloc, InitialsFormState>(
      'emits correct states when initials are valid and submitted',
      build: () => InitialsFormBloc(
        leaderboardResource: leaderboardResource,
        scoreCardId: 'scoreCardId',
      ),
      act: (bloc) {
        bloc
          ..add(InitialsChanged(index: 0, initial: 'A'))
          ..add(InitialsChanged(index: 1, initial: 'B'))
          ..add(InitialsChanged(index: 2, initial: 'C'))
          ..add(InitialsSubmitted());
      },
      expect: () => <InitialsFormState>[
        InitialsFormState(initials: const ['A', '', '']),
        InitialsFormState(initials: const ['A', 'B', '']),
        InitialsFormState(initials: const ['A', 'B', 'C']),
        InitialsFormState(
          initials: const ['A', 'B', 'C'],
          status: InitialsFormStatus.valid,
        ),
        InitialsFormState(
          initials: const ['A', 'B', 'C'],
          status: InitialsFormStatus.success,
        ),
      ],
    );

    blocTest<InitialsFormBloc, InitialsFormState>(
      'emits state with invalid status when initials are not valid and '
      'submitted',
      build: () => InitialsFormBloc(
        leaderboardResource: leaderboardResource,
        scoreCardId: 'scoreCardId',
      ),
      act: (bloc) {
        bloc
          ..add(InitialsChanged(index: 0, initial: 'A'))
          ..add(InitialsSubmitted());
      },
      expect: () => <InitialsFormState>[
        InitialsFormState(initials: const ['A', '', '']),
        InitialsFormState(
          initials: const ['A', '', ''],
          status: InitialsFormStatus.invalid,
        ),
      ],
    );

    blocTest<InitialsFormBloc, InitialsFormState>(
      'emits state with blacklisted status when initials are blacklisted and '
      'submitted',
      build: () => InitialsFormBloc(
        leaderboardResource: leaderboardResource,
        scoreCardId: 'scoreCardId',
      ),
      seed: () => InitialsFormState(initials: const ['W', 'T', 'F']),
      act: (bloc) {
        bloc.add(InitialsSubmitted());
      },
      expect: () => <InitialsFormState>[
        InitialsFormState(
          initials: const ['W', 'T', 'F'],
          status: InitialsFormStatus.blacklisted,
        ),
      ],
    );

    blocTest<InitialsFormBloc, InitialsFormState>(
      'emits failure state if adding initials fails',
      setUp: () {
        when(
          () => leaderboardResource.addInitialsToScoreCard(
            scoreCardId: any(named: 'scoreCardId'),
            initials: any(named: 'initials'),
          ),
        ).thenThrow(Exception());
      },
      build: () => InitialsFormBloc(
        leaderboardResource: leaderboardResource,
        scoreCardId: 'scoreCardId',
      ),
      seed: () => InitialsFormState(initials: const ['A', 'B', 'C']),
      act: (bloc) {
        bloc.add(InitialsSubmitted());
      },
      expect: () => <InitialsFormState>[
        InitialsFormState(
          initials: const ['A', 'B', 'C'],
          status: InitialsFormStatus.valid,
        ),
        InitialsFormState(
          initials: const ['A', 'B', 'C'],
          status: InitialsFormStatus.failure,
        ),
      ],
    );
  });
}
