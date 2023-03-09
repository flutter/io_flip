// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/match_making/match_making.dart';

import '../../helpers/helpers.dart';

class _MockMatchMakingBloc extends Mock implements MatchMakingBloc {}

void main() {
  group('MatchMakingView', () {
    late MatchMakingBloc bloc;

    setUp(() {
      bloc = _MockMatchMakingBloc();
    });

    void mockState(MatchMakingState state) {
      whenListen(
        bloc,
        Stream.value(state),
        initialState: state,
      );
    }

    testWidgets('renders a loading when on initial', (tester) async {
      mockState(MatchMakingState.initial());
      await tester.pumpSubject(bloc);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders an error message when it fails', (tester) async {
      mockState(MatchMakingState(status: MatchMakingStatus.failed));
      await tester.pumpSubject(bloc);
      expect(find.text('Match making failed, sorry!'), findsOneWidget);
    });

    testWidgets(
      'renders the host and guest id when match making is completed',
      (tester) async {
        mockState(
          MatchMakingState(
            status: MatchMakingStatus.completed,
            match: Match(
              id: 'matchId',
              host: 'hostId',
              guest: 'guestId',
              hostPing: Timestamp.now(),
              guestPing: Timestamp.now(),
            ),
            isHost: true,
          ),
        );
        final goRouter = MockGoRouter();
        await tester.pumpSubject(bloc, goRouter: goRouter);

        verify(
          () => goRouter.go('/game/matchId/true'),
        ).called(1);
      },
    );
  });
}

extension MatchMakingViewTest on WidgetTester {
  Future<void> pumpSubject(
    MatchMakingBloc bloc, {
    GoRouter? goRouter,
  }) {
    return pumpApp(
      MockGoRouterProvider(
        goRouter: goRouter ?? MockGoRouter(),
        child: BlocProvider<MatchMakingBloc>.value(
          value: bloc,
          child: MatchMakingView(),
        ),
      ),
    );
  }
}
