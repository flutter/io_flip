// ignore_for_file: prefer_const_constructors

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/leaderboard/initials_form/initials_form.dart';

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
      act: (bloc) => bloc.add(InitialsChanged(initials: 'ABC')),
      expect: () => <InitialsFormState>[
        InitialsFormState(initials: 'ABC'),
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
          ..add(InitialsChanged(initials: 'ABC'))
          ..add(InitialsSubmitted());
      },
      expect: () => <InitialsFormState>[
        InitialsFormState(initials: 'ABC'),
        InitialsFormState(initials: 'ABC', status: InitialsFormStatus.valid),
        InitialsFormState(initials: 'ABC', status: InitialsFormStatus.success),
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
          ..add(InitialsChanged(initials: 'AB'))
          ..add(InitialsSubmitted());
      },
      expect: () => <InitialsFormState>[
        InitialsFormState(initials: 'AB'),
        InitialsFormState(initials: 'AB', status: InitialsFormStatus.invalid),
      ],
    );

    blocTest<InitialsFormBloc, InitialsFormState>(
      'emits state with blacklisted status when initials are blacklisted and '
      'submitted',
      build: () => InitialsFormBloc(
        leaderboardResource: leaderboardResource,
        scoreCardId: 'scoreCardId',
      ),
      act: (bloc) {
        bloc
          ..add(InitialsChanged(initials: 'WTF'))
          ..add(InitialsSubmitted());
      },
      expect: () => <InitialsFormState>[
        InitialsFormState(initials: 'WTF'),
        InitialsFormState(
          initials: 'WTF',
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
      act: (bloc) {
        bloc
          ..add(InitialsChanged(initials: 'ABC'))
          ..add(InitialsSubmitted());
      },
      expect: () => <InitialsFormState>[
        InitialsFormState(initials: 'ABC'),
        InitialsFormState(initials: 'ABC', status: InitialsFormStatus.valid),
        InitialsFormState(initials: 'ABC', status: InitialsFormStatus.failure),
      ],
    );
  });
}
