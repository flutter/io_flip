// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:top_dash/draft/draft.dart';

import '../../helpers/helpers.dart';

class _MockDraftBloc extends Mock implements DraftBloc {}

void main() {
  group('DraftView', () {
    late DraftBloc draftBloc;

    const card1 = Card(
      id: '1',
      name: 'card1',
      description: '',
      rarity: false,
      image: '',
      power: 1,
    );

    const card2 = Card(
      id: '2',
      name: 'card2',
      description: '',
      rarity: true,
      image: '',
      power: 1,
    );

    const card3 = Card(
      id: '2',
      name: 'card2',
      description: '',
      rarity: true,
      image: '',
      power: 1,
    );

    void mockState(List<DraftState> states) {
      whenListen(
        draftBloc,
        Stream.fromIterable(states),
        initialState: states.first,
      );
    }

    setUp(() {
      draftBloc = _MockDraftBloc();
      const state = DraftState.initial();
      mockState([state]);
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
          )
        ],
      );
      await tester.pumpSubject(draftBloc: draftBloc);

      await tester.tap(find.text('Use card'));
      await tester.pumpAndSettle();

      verify(() => draftBloc.add(SelectCard())).called(1);
    });

    testWidgets('can go to the next card', (tester) async {
      mockState(
        [
          DraftState(
            cards: const [card1, card2],
            selectedCards: const [],
            status: DraftStateStatus.deckLoaded,
          )
        ],
      );
      await tester.pumpSubject(draftBloc: draftBloc);

      await tester.tap(find.text('Next card'));
      await tester.pumpAndSettle();

      verify(() => draftBloc.add(NextCard())).called(1);
    });

    testWidgets('renders an error message when loading failed', (tester) async {
      mockState(
        [
          DraftState(
            cards: const [card1, card2],
            selectedCards: const [],
            status: DraftStateStatus.deckFailed,
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
            )
          ],
        );
        await tester.pumpSubject(draftBloc: draftBloc);

        expect(find.text('Play'), findsOneWidget);
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
            )
          ],
        );
        await tester.pumpSubject(
          draftBloc: draftBloc,
          goRouter: goRouter,
        );

        await tester.tap(find.text('Play'));
        verify(
          () => goRouter.goNamed(
            'match_making',
            queryParams: {
              'cardId': [card1, card2, card3].map((card) => card.id).toList(),
            },
          ),
        ).called(1);
      },
    );
  });
}

extension DraftViewTest on WidgetTester {
  Future<void> pumpSubject({
    required DraftBloc draftBloc,
    GoRouter? goRouter,
  }) async {
    await mockNetworkImages(() {
      return pumpApp(
        MockGoRouterProvider(
          goRouter: goRouter ?? MockGoRouter(),
          child: BlocProvider.value(
            value: draftBloc,
            child: DraftView(),
          ),
        ),
      );
    });
  }
}
