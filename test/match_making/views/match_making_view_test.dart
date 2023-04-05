// ignore_for_file: prefer_const_constructors, one_member_abstracts

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/game/game.dart';
import 'package:top_dash/match_making/match_making.dart';
import 'package:web_socket_client/web_socket_client.dart';

import '../../helpers/helpers.dart';

class _MockMatchMakingBloc extends Mock implements MatchMakingBloc {}

class _MockWebSocket extends Mock implements WebSocket {}

abstract class __Router {
  void neglect(BuildContext context, VoidCallback callback);
}

class _MockRouter extends Mock implements __Router {}

class _MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('MatchMakingView', () {
    late MatchMakingBloc bloc;
    late __Router router;
    final webSocket = _MockWebSocket();

    setUp(() {
      bloc = _MockMatchMakingBloc();
      router = _MockRouter();
      when(() => router.neglect(any(), any())).thenAnswer((_) {
        final callback = _.positionalArguments[1] as VoidCallback;
        callback();
      });
    });

    setUpAll(() {
      registerFallbackValue(_MockBuildContext());
      registerFallbackValue(
        GamePageData(
          isHost: true,
          matchId: null,
          matchConnection: webSocket,
        ),
      );
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

    testWidgets(
      'renders a timeout message when match times out',
      (tester) async {
        mockState(MatchMakingState(status: MatchMakingStatus.timeout));
        await tester.pumpSubject(bloc);
        expect(find.text('Match making timed out, sorry!'), findsOneWidget);
      },
    );

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
            ),
            isHost: true,
            matchConnection: webSocket,
          ),
        );
        final goRouter = MockGoRouter();
        await tester.pumpSubject(
          bloc,
          goRouter: goRouter,
          routerNeglectCall: router.neglect,
        );

        final data = GamePageData(
          isHost: true,
          matchId: 'matchId',
          matchConnection: webSocket,
        );
        verify(
          () => goRouter.goNamed(
            'game',
            extra: data,
          ),
        ).called(1);
      },
    );

    testWidgets(
      'renders the invite code button when one is available',
      (tester) async {
        mockState(
          MatchMakingState(
            status: MatchMakingStatus.processing,
            match: Match(
              id: 'matchId',
              host: 'hostId',
              guest: 'guestId',
              inviteCode: 'hello-join-my-match',
            ),
            isHost: true,
          ),
        );
        await tester.pumpSubject(bloc);

        expect(
          find.text('Copy invite code'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'copies invite code on invite code button tap',
      (tester) async {
        ClipboardData? clipboardData;
        mockState(
          MatchMakingState(
            status: MatchMakingStatus.processing,
            match: Match(
              id: 'matchId',
              host: 'hostId',
              guest: 'guestId',
              inviteCode: 'hello-join-my-match',
            ),
            isHost: true,
          ),
        );
        await tester.pumpSubject(
          bloc,
          setClipboardData: (data) async => clipboardData = data,
        );

        await tester.tap(find.text('Copy invite code'));
        await tester.pump();

        expect(
          clipboardData?.text,
          equals('hello-join-my-match'),
        );
      },
    );
  });
}

extension MatchMakingViewTest on WidgetTester {
  Future<void> pumpSubject(
    MatchMakingBloc bloc, {
    GoRouter? goRouter,
    Future<void> Function(ClipboardData)? setClipboardData,
    RouterNeglectCall routerNeglectCall = Router.neglect,
  }) {
    return pumpApp(
      BlocProvider<MatchMakingBloc>.value(
        value: bloc,
        child: MatchMakingView(
          setClipboardData: setClipboardData ?? Clipboard.setData,
          routerNeglectCall: routerNeglectCall,
        ),
      ),
      router: goRouter,
    );
  }
}
