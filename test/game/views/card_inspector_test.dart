import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:top_dash/share/share.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

import '../../helpers/helpers.dart';

class _MockShareResource extends Mock implements ShareResource {}

class _MockGoRouterState extends Mock implements GoRouterState {}

void main() {
  late GoRouterState goRouterState;

  Card card(String id) => Card(
        id: id,
        name: id,
        description: 'description',
        image: '',
        rarity: false,
        power: 1,
        suit: Suit.air,
      );
  final deck = [card('1'), card('2'), card('3')];
  final data = CardInspectorData(
    deck: deck,
    playerCardIds: const ['1', '2', '3'],
    startingIndex: 1,
  );
  setUp(() {
    goRouterState = _MockGoRouterState();
    when(() => goRouterState.extra).thenReturn(
      data,
    );
  });

  group('CardInspector', () {
    Widget buildSubject() => CardInspector(
          deck: deck,
          playerCardIds: const ['1', '2', '3'],
          startingIndex: 0,
        );

    test('routeBuilder returns a GamePage', () {
      expect(
        CardInspector.routeBuilder(null, goRouterState),
        isA<CardInspector>()
            .having((page) => page.deck, 'deck', equals(data.deck))
            .having(
              (page) => page.playerCardIds,
              'playerCardIds',
              equals(data.playerCardIds),
            )
            .having(
              (page) => page.startingIndex,
              'startingIndex',
              data.startingIndex,
            ),
      );
    });

    testWidgets('renders', (tester) async {
      await tester.pumpSubject(buildSubject());

      expect(find.byType(CardInspector), findsOneWidget);
    });

    testWidgets('renders a GameCard', (tester) async {
      await tester.pumpSubject(buildSubject());

      expect(find.byType(GameCard), findsOneWidget);
    });

    testWidgets('renders a share button', (tester) async {
      await tester.pumpSubject(buildSubject());

      expect(find.byIcon(Icons.share_outlined), findsOneWidget);
    });

    testWidgets(
      'pops navigation when the close button is tapped ',
      (tester) async {
        final goRouter = MockGoRouter();

        await tester.pumpSubject(
          buildSubject(),
          router: goRouter,
        );

        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();

        verify(goRouter.pop).called(1);
      },
    );

    testWidgets('renders a dialog on share button tapped', (tester) async {
      final shareResource = _MockShareResource();
      when(() => shareResource.facebookShareCardUrl(any())).thenReturn('');
      when(() => shareResource.twitterShareCardUrl(any())).thenReturn('');
      when(shareResource.shareGameUrl).thenReturn('');

      await tester.pumpSubject(buildSubject(), shareResource: shareResource);
      await tester.tap(find.byIcon(Icons.share_outlined));
      await tester.pumpAndSettle();
      expect(find.byType(ShareDialog), findsOneWidget);
    });

    group('landscape mode', () {
      testWidgets('renders', (tester) async {
        tester.setLandscapeDisplaySize();
        await tester.pumpSubject(buildSubject());
        expect(
          find.byKey(const Key('LandscapeCardViewer')),
          findsOneWidget,
        );
      });

      testWidgets(
        'tapping the next button moves to the next card',
        (tester) async {
          tester.setLandscapeDisplaySize();
          await tester.pumpSubject(buildSubject());
          expect(find.byKey(const ValueKey('GameCard0')), findsOneWidget);
          await tester.tap(find.byIcon(Icons.arrow_forward_ios));
          await tester.pumpAndSettle();
          expect(find.byKey(const ValueKey('GameCard1')), findsOneWidget);
        },
      );

      testWidgets(
        'tapping the previous button moves to the previous card',
        (tester) async {
          tester.setLandscapeDisplaySize();
          await tester.pumpSubject(buildSubject());
          expect(find.byKey(const ValueKey('GameCard0')), findsOneWidget);
          await tester.tap(find.byIcon(Icons.arrow_back_ios));
          await tester.pumpAndSettle();
          expect(find.byKey(const ValueKey('GameCard2')), findsOneWidget);
        },
      );
    });

    group('portrait mode', () {
      testWidgets('renders', (tester) async {
        tester.setPortraitDisplaySize();
        await tester.pumpSubject(buildSubject());
        expect(
          find.byKey(const Key('PortraitCardViewer')),
          findsOneWidget,
        );
      });

      testWidgets(
        'tapping the next button moves to the next card',
        (tester) async {
          tester.setPortraitDisplaySize();
          await tester.pumpSubject(buildSubject());
          expect(find.byKey(const ValueKey('GameCard0')), findsOneWidget);
          await tester.tap(find.byIcon(Icons.arrow_forward_ios));
          await tester.pumpAndSettle();
          expect(find.byKey(const ValueKey('GameCard1')), findsOneWidget);
        },
      );

      testWidgets(
        'tapping the previous button moves to the previous card',
        (tester) async {
          tester.setPortraitDisplaySize();
          await tester.pumpSubject(buildSubject());
          expect(find.byKey(const ValueKey('GameCard0')), findsOneWidget);
          await tester.tap(find.byIcon(Icons.arrow_back_ios));
          await tester.pumpAndSettle();
          expect(find.byKey(const ValueKey('GameCard2')), findsOneWidget);
        },
      );
    });
  });
  group('CardInspectorData', () {
    test('handles equality', () {
      expect(
        CardInspectorData(
          playerCardIds: data.playerCardIds,
          deck: data.deck,
          startingIndex: data.startingIndex,
        ),
        data,
      );
      expect(
        CardInspectorData(
          playerCardIds: data.playerCardIds,
          deck: data.deck,
        ),
        isNot(data),
      );
    });
  });
}

extension CardInspectorTest on WidgetTester {
  Future<void> pumpSubject(
    Widget widget, {
    GoRouter? router,
    ShareResource? shareResource,
  }) async {
    await mockNetworkImages(() {
      return pumpApp(widget, router: router, shareResource: shareResource);
    });
  }
}
