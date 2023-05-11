// ignore_for_file: prefer_const_constructors, one_member_abstracts

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:io_flip/game/game.dart';
import 'package:io_flip/match_making/match_making.dart';
import 'package:io_flip/settings/settings.dart';
import 'package:io_flip/utils/utils.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../helpers/helpers.dart';

class _MockMatchMakingBloc extends Mock implements MatchMakingBloc {}

class _MockSettingsController extends Mock implements SettingsController {}

class _MockRouter extends Mock implements NeglectRouter {}

class _MockBuildContext extends Mock implements BuildContext {}

const deck = Deck(
  id: 'deckId',
  userId: 'userId',
  cards: [
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
);

void main() {
  group('MatchMakingView', () {
    late MatchMakingBloc bloc;
    late NeglectRouter router;

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
          deck: deck,
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

      testWidgets('renders the players deck', (tester) async {
        mockState(MatchMakingState.initial());
        await tester.pumpSubject(bloc);
        expect(find.byType(GameCard), findsNWidgets(3));
      });

      testWidgets('renders the title in landscape mode', (tester) async {
        tester.setLandscapeDisplaySize();
        mockState(MatchMakingState.initial());
        await tester.pumpSubject(bloc);

        expect(find.text(tester.l10n.findingMatch), findsOneWidget);
        expect(find.text(tester.l10n.searchingForOpponents), findsOneWidget);
        expect(
          find.byKey(const Key('large_waiting_for_match_view')),
          findsOneWidget,
        );
      });

      testWidgets('renders the title in portrait mode', (tester) async {
        tester.setPortraitDisplaySize();
        mockState(MatchMakingState.initial());
        await tester.pumpSubject(bloc);

        expect(find.text(tester.l10n.findingMatch), findsOneWidget);
        expect(find.text(tester.l10n.searchingForOpponents), findsOneWidget);
        expect(
          find.byKey(const Key('small_waiting_for_match_view')),
          findsOneWidget,
        );
      });

      testWidgets(
        'renders the invite code button when one is available',
        (tester) async {
          mockState(
            MatchMakingState(
              status: MatchMakingStatus.processing,
              match: DraftMatch(
                id: 'matchId',
                host: 'hostId',
                guest: 'guestId',
                inviteCode: 'hello-join-my-match',
              ),
              isHost: true,
            ),
          );
          await tester.pumpSubject(bloc);

          expect(find.text(tester.l10n.copyInviteCode), findsOneWidget);
        },
      );

      testWidgets(
        'copies invite code on invite code button tap',
        (tester) async {
          ClipboardData? clipboardData;
          mockState(
            MatchMakingState(
              status: MatchMakingStatus.processing,
              match: DraftMatch(
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

          await tester.tap(find.text(tester.l10n.copyInviteCode));
          await tester.pump();

          expect(
            clipboardData?.text,
            equals('hello-join-my-match'),
          );
        },
      );
    });
    testWidgets(
      'renders a timeout message when match making times out and navigates to '
      'match making again',
      (tester) async {
        mockState(MatchMakingState(status: MatchMakingStatus.timeout));

        await tester.pumpSubject(bloc);

        expect(find.text('Match making timed out, sorry!'), findsOneWidget);

        await tester.tap(find.byType(RoundedButton));
        await tester.pumpAndSettle();
        verify(() => bloc.add(PrivateMatchRequested())).called(1);
      },
    );

    testWidgets(
      'renders an error message when it fails adds event to the bloc on retry',
      (tester) async {
        mockState(MatchMakingState(status: MatchMakingStatus.failed));

        await tester.pumpSubject(bloc);

        expect(find.text('Match making failed, sorry!'), findsOneWidget);

        await tester.tap(find.byType(RoundedButton));
        await tester.pumpAndSettle();

        verify(() => bloc.add(PrivateMatchRequested())).called(1);
      },
    );

    testWidgets(
      'renders transition screen when matchmaking is completed, before going '
      'to the game page',
      (tester) async {
        mockState(
          MatchMakingState(
            status: MatchMakingStatus.completed,
            match: DraftMatch(
              id: 'matchId',
              host: 'hostId',
              guest: 'guestId',
            ),
            isHost: true,
          ),
        );
        await tester.pumpSubject(
          bloc,
          routerNeglectCall: router.neglect,
        );

        expect(find.text(tester.l10n.getReadyToFlip), findsOneWidget);

        // Let timers finish before ending test
        await tester.pump(Duration(seconds: 3));
      },
    );

    testWidgets(
      'navigates to game page once matchmaking is completed',
      (tester) async {
        mockState(
          MatchMakingState(
            status: MatchMakingStatus.completed,
            match: DraftMatch(
              id: 'matchId',
              host: 'hostId',
              guest: 'guestId',
            ),
            isHost: true,
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
          deck: deck,
        );

        await tester.pump(Duration(seconds: 3));

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
    RouterNeglectCall routerNeglectCall = Router.neglect,
    MatchMakingEvent? tryAgainEvent,
  }) {
    final SettingsController settingsController = _MockSettingsController();

    return mockNetworkImages(() {
      return pumpApp(
        BlocProvider<MatchMakingBloc>.value(
          value: bloc,
          child: MatchMakingView(
            setClipboardData: setClipboardData ?? Clipboard.setData,
            routerNeglectCall: routerNeglectCall,
            deck: deck,
            tryAgainEvent: tryAgainEvent ?? PrivateMatchRequested(),
          ),
        ),
        router: goRouter,
        settingsController: settingsController,
      );
    });
  }
}
