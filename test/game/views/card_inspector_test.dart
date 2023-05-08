import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:io_flip/share/share.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../helpers/helpers.dart';

class _MockShareResource extends Mock implements ShareResource {}

void main() {
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

  setUp(() {});

  group('CardInspector', () {
    Widget buildSubject() => CardInspectorDialog(
          deck: deck,
          playerCardIds: const ['1', '2', '3'],
          startingIndex: 0,
        );

    testWidgets('renders', (tester) async {
      await tester.pumpSubject(buildSubject());

      expect(find.byType(CardInspectorDialog), findsOneWidget);
    });

    testWidgets('renders a GameCard', (tester) async {
      await tester.pumpSubject(buildSubject());

      expect(find.byType(GameCard), findsOneWidget);
    });

    testWidgets('renders a share button', (tester) async {
      await tester.pumpSubject(buildSubject());

      expect(find.byIcon(Icons.share_outlined), findsOneWidget);
    });

    testWidgets('can go to the next card by tapping forward button',
        (tester) async {
      await tester.pumpSubject(buildSubject());
      final card = find.byWidgetPredicate(
        (widget) => widget is GameCard && widget.name == '1',
      );
      expect(card, findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();
      final nextCard = find.byWidgetPredicate(
        (widget) => widget is GameCard && widget.name == '2',
      );
      expect(nextCard, findsOneWidget);
    });

    testWidgets('can go to the previous card by back button', (tester) async {
      await tester.pumpSubject(buildSubject());
      final card = find.byWidgetPredicate(
        (widget) => widget is GameCard && widget.name == '1',
      );
      expect(card, findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      final previousCard = find.byWidgetPredicate(
        (widget) => widget is GameCard && widget.name == '3',
      );
      expect(previousCard, findsOneWidget);
    });

    testWidgets(
      'pops navigation when around the card is tapped ',
      (tester) async {
        final goRouter = MockGoRouter();

        await tester.pumpSubject(
          buildSubject(),
          router: goRouter,
        );
        final containerFinder = find.byType(GameCard);
        final containerBox = tester.getRect(containerFinder);
        final tapPosition =
            Offset(containerBox.right + 10, containerBox.top + 10);
        await tester.tapAt(tapPosition);

        await tester.pumpAndSettle();

        verify(goRouter.pop).called(1);
      },
    );

    testWidgets(
      'does not pop navigation when the card is tapped ',
      (tester) async {
        final goRouter = MockGoRouter();

        await tester.pumpSubject(
          buildSubject(),
          router: goRouter,
        );
        await tester.tap(find.byType(GameCard));

        await tester.pumpAndSettle();

        verifyNever(goRouter.pop);
      },
    );

    testWidgets('renders a dialog on share button tapped', (tester) async {
      final shareResource = _MockShareResource();
      when(() => shareResource.facebookShareCardUrl(any())).thenReturn('');
      when(() => shareResource.twitterShareCardUrl(any())).thenReturn('');

      await tester.pumpSubject(buildSubject(), shareResource: shareResource);
      await tester.tap(find.byIcon(Icons.share_outlined));
      await tester.pumpAndSettle();
      expect(find.byType(ShareDialog), findsOneWidget);
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
