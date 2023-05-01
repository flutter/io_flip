// ignore_for_file: prefer_const_constructors, one_member_abstracts

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/cache.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:top_dash/draft/draft.dart';
import 'package:top_dash/draft/widgets/widgets.dart';
import 'package:top_dash/how_to_play/how_to_play.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/match_making/views/match_making_page.dart';
import 'package:top_dash/settings/settings.dart';

import '../../helpers/helpers.dart';

class _MockDraftBloc extends Mock implements DraftBloc {}

class _MockSettingsController extends Mock implements SettingsController {}

abstract class __Router {
  void neglect(BuildContext context, VoidCallback callback);
}

class _MockRouter extends Mock implements __Router {}

class _MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('DraftView', () {
    late DraftBloc draftBloc;
    late __Router router;

    const card1 = Card(
      id: '1',
      name: 'card1',
      description: '',
      rarity: false,
      image: '',
      power: 1,
      suit: Suit.air,
    );

    const card2 = Card(
      id: '2',
      name: 'card2',
      description: '',
      rarity: true,
      image: '',
      power: 1,
      suit: Suit.air,
    );

    const card3 = Card(
      id: '3',
      name: 'card3',
      description: '',
      rarity: true,
      image: '',
      power: 1,
      suit: Suit.air,
    );

    void mockState(List<DraftState> states) {
      whenListen(
        draftBloc,
        Stream.fromIterable(states),
        initialState: states.first,
      );
    }

    setUpAll(() {
      registerFallbackValue(_MockBuildContext());
    });

    setUp(() {
      draftBloc = _MockDraftBloc();
      const state = DraftState.initial();
      mockState([state]);

      router = _MockRouter();
      when(() => router.neglect(any(), any())).thenAnswer((_) {
        final callback = _.positionalArguments[1] as VoidCallback;
        callback();
      });
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpSubject(draftBloc: draftBloc);

      expect(find.byType(DraftView), findsOneWidget);
    });

    testWidgets('renders the loaded cards', (tester) async {
      mockState(
        [
          DraftState(
            cards: const [card1, card2],
            selectedCards: const [],
            status: DraftStateStatus.deckLoaded,
            firstCardOpacity: 1,
          )
        ],
      );
      await tester.pumpSubject(draftBloc: draftBloc);

      expect(find.text('card1'), findsOneWidget);
      expect(find.text('card2'), findsOneWidget);
    });

    testWidgets('selects the top card', (tester) async {
      mockState(
        [
          DraftState(
            cards: const [card1, card2],
            selectedCards: const [],
            status: DraftStateStatus.deckLoaded,
            firstCardOpacity: 1,
          )
        ],
      );
      await tester.pumpSubject(draftBloc: draftBloc);

      await tester.tap(find.byKey(ValueKey('SelectedCard0')));
      await tester.pumpAndSettle();

      verify(() => draftBloc.add(SelectCard(0))).called(1);
    });

    testWidgets('can go to the next card by swiping', (tester) async {
      mockState(
        [
          DraftState(
            cards: const [card1, card2],
            selectedCards: const [],
            status: DraftStateStatus.deckLoaded,
            firstCardOpacity: 1,
          )
        ],
      );
      await tester.pumpSubject(draftBloc: draftBloc);
      await tester.drag(
        find.byKey(ValueKey(card1.id)),
        Offset(double.maxFinite, 0),
      );
      await tester.pumpAndSettle();

      verify(() => draftBloc.add(CardSwiped())).called(1);
    });

    testWidgets('can go to the next card by tapping icon', (tester) async {
      mockState(
        [
          DraftState(
            cards: const [card1, card2],
            selectedCards: const [],
            status: DraftStateStatus.deckLoaded,
            firstCardOpacity: 1,
          )
        ],
      );
      await tester.pumpSubject(draftBloc: draftBloc);

      await tester.tap(find.byIcon(Icons.arrow_forward_ios));
      await tester.pumpAndSettle();

      verify(() => draftBloc.add(NextCard())).called(1);
    });

    testWidgets('can go to the previous card by tapping icon', (tester) async {
      mockState(
        [
          DraftState(
            cards: const [card1, card2],
            selectedCards: const [],
            status: DraftStateStatus.deckLoaded,
            firstCardOpacity: 1,
          )
        ],
      );
      await tester.pumpSubject(draftBloc: draftBloc);

      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      await tester.pumpAndSettle();

      verify(() => draftBloc.add(PreviousCard())).called(1);
    });

    testWidgets('renders an error message when loading failed', (tester) async {
      mockState(
        [
          DraftState(
            cards: const [card1, card2],
            selectedCards: const [],
            status: DraftStateStatus.deckFailed,
            firstCardOpacity: 1,
          )
        ],
      );
      await tester.pumpSubject(draftBloc: draftBloc);

      expect(
        find.text('Error generating cards, please try again in a few moments'),
        findsOneWidget,
      );
    });

    testWidgets(
      'render the play button once deck is complete',
      (tester) async {
        mockState(
          [
            DraftState(
              cards: const [card1, card2, card3],
              selectedCards: const [card1, card2, card3],
              status: DraftStateStatus.deckSelected,
              firstCardOpacity: 1,
            )
          ],
        );
        await tester.pumpSubject(draftBloc: draftBloc);

        final l10n = tester.element(find.byType(DraftView)).l10n;

        expect(find.text(l10n.joinMatch.toUpperCase()), findsOneWidget);
      },
    );

    testWidgets(
      'navigates to the game lobby when clicking on play',
      (tester) async {
        final goRouter = MockGoRouter();
        mockState(
          [
            DraftState(
              cards: const [card1, card2, card3],
              selectedCards: const [card1, card2, card3],
              status: DraftStateStatus.deckSelected,
              firstCardOpacity: 1,
            )
          ],
        );
        await tester.pumpSubject(
          draftBloc: draftBloc,
          goRouter: goRouter,
          routerNeglectCall: router.neglect,
        );

        final l10n = tester.element(find.byType(DraftView)).l10n;

        await tester.tap(find.text(l10n.joinMatch.toUpperCase()));
        verify(
          () => goRouter.goNamed(
            'match_making',
            extra: MatchMakingPageData(deck: const [card1, card2, card3]),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'navigates to the private match lobby when clicking on create private '
      'match',
      (tester) async {
        final goRouter = MockGoRouter();
        mockState(
          [
            DraftState(
              cards: const [card1, card2, card3],
              selectedCards: const [card1, card2, card3],
              status: DraftStateStatus.deckSelected,
              firstCardOpacity: 1,
            )
          ],
        );
        await tester.pumpSubject(
          draftBloc: draftBloc,
          goRouter: goRouter,
          routerNeglectCall: router.neglect,
        );

        await tester.longPress(find.text(tester.l10n.joinMatch.toUpperCase()));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Create private match'));
        verify(
          () => goRouter.goNamed(
            'match_making',
            queryParams: {
              'createPrivateMatch': 'true',
            },
            extra: MatchMakingPageData(deck: const [card1, card2, card3]),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'navigates to the private guest match lobby when clicking on '
      'join private match and has input an invite code',
      (tester) async {
        final goRouter = MockGoRouter();
        mockState(
          [
            DraftState(
              cards: const [card1, card2, card3],
              selectedCards: const [card1, card2, card3],
              status: DraftStateStatus.deckSelected,
              firstCardOpacity: 1,
            )
          ],
        );
        await tester.pumpSubject(
          draftBloc: draftBloc,
          goRouter: goRouter,
          routerNeglectCall: router.neglect,
        );

        await tester.longPress(find.text(tester.l10n.joinMatch.toUpperCase()));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'invite-code');
        await tester.tap(find.text('Join'));
        await tester.pumpAndSettle();

        verify(
          () => goRouter.goNamed(
            'match_making',
            queryParams: {
              'inviteCode': 'invite-code',
            },
            extra: MatchMakingPageData(deck: const [card1, card2, card3]),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'stay in the page when cancelling the input of the invite code',
      (tester) async {
        final goRouter = MockGoRouter();
        mockState(
          [
            DraftState(
              cards: const [card1, card2, card3],
              selectedCards: const [card1, card2, card3],
              status: DraftStateStatus.deckSelected,
              firstCardOpacity: 1,
            )
          ],
        );
        await tester.pumpSubject(
          draftBloc: draftBloc,
          goRouter: goRouter,
        );

        await tester.longPress(find.text(tester.l10n.joinMatch.toUpperCase()));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'invite-code');
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        verifyNever(
          () => goRouter.goNamed(
            'match_making',
            queryParams: {
              'cardId': [card1, card2, card3].map((card) => card.id).toList(),
              'inviteCode': 'invite-code',
            },
          ),
        );
      },
    );

    testWidgets(
      'navigates to the how to play page',
      (tester) async {
        mockState(
          [
            DraftState(
              cards: const [card1, card2, card3],
              selectedCards: const [card1, card2, card3],
              status: DraftStateStatus.deckSelected,
              firstCardOpacity: 1,
            )
          ],
        );
        await tester.pumpSubject(
          draftBloc: draftBloc,
        );

        await tester.tap(find.byIcon(Icons.question_mark_rounded));
        await tester.pumpAndSettle();

        expect(find.byType(HowToPlayDialog), findsOneWidget);
      },
    );

    testWidgets(
      'can setup animation',
      (tester) async {
        mockState(
          [
            DraftState(
              cards: const [card1, card2],
              selectedCards: const [],
              status: DraftStateStatus.deckLoaded,
              firstCardOpacity: 1,
            )
          ],
        );
        await tester.pumpSubject(draftBloc: draftBloc);
        final deckPackState = tester.state<DeckPackState>(
          find.byType(DeckPack),
        );
        await tester.runAsync(() async {
          await deckPackState.setupAnimation();
        });
        await tester.pump(Duration(seconds: 2));
        deckPackState.onFrame(29);
        expect(deckPackState.anim, isNotNull);
      },
    );
  });
}

extension DraftViewTest on WidgetTester {
  Future<void> pumpSubject({
    required DraftBloc draftBloc,
    GoRouter? goRouter,
    RouterNeglectCall routerNeglectCall = Router.neglect,
  }) async {
    final SettingsController settingsController = _MockSettingsController();
    when(() => settingsController.muted).thenReturn(ValueNotifier(true));

    await mockNetworkImages(() async {
      await pumpApp(
        BlocProvider.value(
          value: draftBloc,
          child: DraftView(
            routerNeglectCall: routerNeglectCall,
          ),
        ),
        images: Images(prefix: ''),
        router: goRouter,
        settingsController: settingsController,
      );

      final deckPackStates = stateList<DeckPackState>(find.byType(DeckPack));
      if (deckPackStates.isNotEmpty) {
        final deckPackState = deckPackStates.first..anim = Container();

        // Complete animation
        await pumpAndSettle();
        deckPackState.onComplete();
        await pump();
      }
    });
  }
}
