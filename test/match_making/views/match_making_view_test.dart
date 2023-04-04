// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart' hide Match;
import 'package:go_router/go_router.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:top_dash/game/game.dart';
import 'package:top_dash/match_making/match_making.dart';
import 'package:top_dash_ui/top_dash_ui.dart';
import 'package:web_socket_client/web_socket_client.dart';

import '../../helpers/helpers.dart';

class _MockMatchMakingBloc extends Mock implements MatchMakingBloc {}

class _MockWebSocket extends Mock implements WebSocket {}

void main() {
  group('MatchMakingView', () {
    late MatchMakingBloc bloc;
    final webSocket = _MockWebSocket();

    setUp(() {
      bloc = _MockMatchMakingBloc();
    });
    setUpAll(() {
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

    group('initial state', () {
      testWidgets('renders a fading dot loading indicator', (tester) async {
        mockState(MatchMakingState.initial());
        await tester.pumpSubject(bloc);
        expect(find.byType(FadingDotLoader), findsOneWidget);
      });

      // testWidgets('renders the players deck', (tester) async {
      //   mockState(MatchMakingState.initial());
      //   await tester.pumpSubject(bloc);
      //   expect(find.byType(GameCard), findsNWidgets(3));
      // });

      testWidgets('renders the title in landscape mode', (tester) async {
        tester.binding.window.devicePixelRatioTestValue = 1;
        tester.binding.window.physicalSizeTestValue = const Size(2000, 1600);
        mockState(MatchMakingState.initial());
        await tester.pumpSubject(bloc);

        final title = find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              // widget.data == 'tester.l10n.findingMatch' &&
              widget.style == TopDashTextStyles.headlineH4Light,
          description: 'Text with headlineH4Light style',
        );

        final subtitle = find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              // widget.data == 'tester.l10n.searchingForOpponents' &&
              widget.style == TopDashTextStyles.headlineH6Light,
          description: 'Text with headlineH6Light style',
        );

        tester.binding.window.clearDevicePixelRatioTestValue();

        expect(title, findsOneWidget);
        expect(subtitle, findsOneWidget);
      });

      testWidgets('renders the title in portrait mode', (tester) async {
        tester.binding.window.devicePixelRatioTestValue = 1;
        tester.binding.window.physicalSizeTestValue = const Size(1200, 1600);
        mockState(MatchMakingState.initial());
        await tester.pumpSubject(bloc);

        final title = find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              // widget.data == 'tester.l10n.findingMatch' &&
              widget.style == TopDashTextStyles.headlineMobileH4Light,
          description: 'Text with headlineH4Light style',
        );

        final subtitle = find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text &&
              // widget.data == 'tester.l10n.searchingForOpponents' &&
              widget.style == TopDashTextStyles.headlineMobileH6Light,
          description: 'Text with headlineH4Light style',
        );

        tester.binding.window.clearDevicePixelRatioTestValue();

        expect(title, findsOneWidget);
        expect(subtitle, findsOneWidget);
      });

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

          expect(find.text('context.l10n.copyInviteCode'), findsOneWidget);
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

          await tester.tap(find.text('context.l10n.copyInviteCode'));
          await tester.pump();

          expect(
            clipboardData?.text,
            equals('hello-join-my-match'),
          );
        },
      );
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
        await tester.pumpSubject(bloc, goRouter: goRouter);
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
  });
}

extension MatchMakingViewTest on WidgetTester {
  Future<void> pumpSubject(
    MatchMakingBloc bloc, {
    GoRouter? goRouter,
    Future<void> Function(ClipboardData)? setClipboardData,
    List<Card>? deck,
  }) {
    return mockNetworkImages(() {
      return pumpApp(
        BlocProvider<MatchMakingBloc>.value(
          value: bloc,
          child: MatchMakingView(
            setClipboardData: setClipboardData ?? Clipboard.setData,
            deck: deck ??
                [
                  Card(
                    id: 'a',
                    name: '',
                    description: '',
                    image: '',
                    power: 1,
                    rarity: false,
                    suit: Suit.air,
                  ),
                  Card(
                    id: 'b',
                    name: '',
                    description: '',
                    image: '',
                    power: 1,
                    rarity: false,
                    suit: Suit.air,
                  ),
                  Card(
                    id: 'c',
                    name: '',
                    description: '',
                    image: '',
                    power: 1,
                    rarity: false,
                    suit: Suit.air,
                  ),
                ],
          ),
        ),
        router: goRouter,
      );
    });
  }
}
