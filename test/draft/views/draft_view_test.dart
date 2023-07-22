// ignore_for_file: prefer_const_constructors, one_member_abstracts

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flame/cache.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:io_flip/audio/audio_controller.dart';
import 'package:io_flip/draft/draft.dart';
import 'package:io_flip/gen/assets.gen.dart';
import 'package:io_flip/how_to_play/how_to_play.dart';
import 'package:io_flip/l10n/l10n.dart';
import 'package:io_flip/match_making/match_making.dart';
import 'package:io_flip/settings/settings.dart';
import 'package:io_flip/share/share.dart';
import 'package:io_flip/utils/utils.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../helpers/helpers.dart';

class _MockDraftBloc extends Mock implements DraftBloc {}

class _MockSettingsController extends Mock implements SettingsController {}

class _MockRouter extends Mock implements NeglectRouter {}

class _MockBuildContext extends Mock implements BuildContext {}

class _MockAudioController extends Mock implements AudioController {}

class _MockShareResource extends Mock implements ShareResource {}

void main() {
  group('DraftView', () {
    late DraftBloc draftBloc;
    late NeglectRouter router;

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

    testWidgets('precaches all images', (tester) async {
      final images = <ImageProvider<Object>>[];
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
      await tester.pumpSubject(
        draftBloc: draftBloc,
        cacheImage: (provider, __) async {
          images.add(provider);
        },
      );

      expect(
        images,
        containsAll([NetworkImage(card1.image), NetworkImage(card2.image)]),
      );
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
      await tester.pumpAndSettle();

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

    testWidgets(
      'opens share dialog card by tapping share icon',
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

        await tester.tap(find.byIcon(Icons.share_outlined));
        await tester.pumpAndSettle();

        expect(find.byType(ShareCardDialog), findsOneWidget);
      },
    );

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
      'requests player deck creation when clicking on play',
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
          () => draftBloc.add(
            PlayerDeckRequested([card1.id, card2.id, card3.id]),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'requests player deck creation when clicking on create private match',
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
          () => draftBloc.add(
            PlayerDeckRequested(
              [card1.id, card2.id, card3.id],
              createPrivateMatch: true,
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'navigates to matchmaking when player deck is created',
      (tester) async {
        final goRouter = MockGoRouter();
        final deck = Deck(
          id: 'deckId',
          userId: 'userId',
          cards: const [card1, card2, card3],
        );
        final baseState = DraftState(
          cards: const [card1, card2, card3],
          selectedCards: const [card1, card2, card3],
          status: DraftStateStatus.deckSelected,
          firstCardOpacity: 1,
        );

        whenListen(
          draftBloc,
          Stream.fromIterable([
            baseState,
            baseState.copyWith(
              status: DraftStateStatus.playerDeckCreated,
              deck: deck,
            ),
          ]),
          initialState: baseState,
        );

        await tester.pumpSubject(
          draftBloc: draftBloc,
          goRouter: goRouter,
          routerNeglectCall: router.neglect,
        );

        verify(
          () => goRouter.goNamed(
            'match_making',
            extra: MatchMakingPageData(deck: deck),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'navigates to private matchmaking when player deck is created with '
      'private match options',
      (tester) async {
        final goRouter = MockGoRouter();
        final deck = Deck(
          id: 'deckId',
          userId: 'userId',
          cards: const [card1, card2, card3],
        );
        final baseState = DraftState(
          cards: const [card1, card2, card3],
          selectedCards: const [card1, card2, card3],
          status: DraftStateStatus.deckSelected,
          firstCardOpacity: 1,
        );

        whenListen(
          draftBloc,
          Stream.fromIterable([
            baseState,
            baseState.copyWith(
              status: DraftStateStatus.playerDeckCreated,
              createPrivateMatch: true,
              privateMatchInviteCode: 'code',
              deck: deck,
            ),
          ]),
          initialState: baseState,
        );

        await tester.pumpSubject(
          draftBloc: draftBloc,
          goRouter: goRouter,
          routerNeglectCall: router.neglect,
        );

        verify(
          () => goRouter.goNamed(
            'match_making',
            extra: MatchMakingPageData(
              deck: deck,
              createPrivateMatch: true,
              inviteCode: 'code',
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'requests player deck creation with an invite code when clicking on '
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
          () => draftBloc.add(
            PlayerDeckRequested(
              [card1.id, card2.id, card3.id],
              privateMatchInviteCode: 'invite-code',
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'does not navigates to the private match lobby when clicking on create '
      'private match and private matches are disabled.',
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
          allowPrivateMatch: 'false',
        );

        await tester.longPress(find.text(tester.l10n.joinMatch.toUpperCase()));
        await tester.pumpAndSettle();

        expect(find.text('Create private match'), findsNothing);
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
      'contains deck pack animation',
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
        final audioController = _MockAudioController();
        await tester.pumpSubject(
          draftBloc: draftBloc,
          audioController: audioController,
        );

        expect(find.byType(DeckPack), findsOneWidget);
      },
    );

    testWidgets(
      'plays card movement sfx correctly',
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
        final audioController = _MockAudioController();
        await tester.pumpSubject(
          draftBloc: draftBloc,
          audioController: audioController,
        );
        final buttonFinder = find.byIcon(Icons.arrow_back_ios_new);
        expect(buttonFinder, findsOneWidget);
        await tester.tap(buttonFinder);
        verify(
          () => audioController.playSfx(Assets.sfx.cardMovement),
        ).called(1);
      },
    );
  });
}

extension DraftViewTest on WidgetTester {
  Future<void> pumpSubject({
    required DraftBloc draftBloc,
    GoRouter? goRouter,
    RouterNeglectCall routerNeglectCall = Router.neglect,
    String allowPrivateMatch = 'true',
    AudioController? audioController,
    CacheImageFunction? cacheImage,
  }) async {
    final SettingsController settingsController = _MockSettingsController();
    when(() => settingsController.muted).thenReturn(ValueNotifier(true));

    final ShareResource shareResource = _MockShareResource();
    when(() => shareResource.twitterShareCardUrl(any())).thenReturn('');
    when(() => shareResource.facebookShareCardUrl(any())).thenReturn('');

    await mockNetworkImages(() async {
      await pumpApp(
        BlocProvider.value(
          value: draftBloc,
          child: DraftView(
            routerNeglectCall: routerNeglectCall,
            allowPrivateMatch: allowPrivateMatch,
            cacheImage: cacheImage ?? (_, __) async {},
          ),
        ),
        images: Images(prefix: ''),
        router: goRouter,
        settingsController: settingsController,
        audioController: audioController,
        shareResource: shareResource,
      );
      await pump();

      final deckPackStates = stateList<DeckPackState>(find.byType(DeckPack));
      if (deckPackStates.isNotEmpty) {
        final deckPackState = deckPackStates.first;

        // Complete animation
        await pumpAndSettle();
        deckPackState.onComplete();
        await pump();
      }
    });
  }
}
