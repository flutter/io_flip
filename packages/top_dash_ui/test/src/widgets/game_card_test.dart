// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

void main() {
  group('GameCard', () {
    for (final suitName in ['fire', 'air', 'earth', 'water', 'metal']) {
      group('when is a $suitName card', () {
        testWidgets('renders correctly', (tester) async {
          await mockNetworkImages(() async {
            await tester.pumpWidget(
              Directionality(
                textDirection: TextDirection.ltr,
                child: GameCard(
                  image: 'image',
                  name: 'name',
                  description: 'description',
                  suitName: suitName,
                  power: 1,
                ),
              ),
            );

            expect(
              find.text('name'),
              findsOneWidget,
            );

            expect(
              find.byWidgetPredicate(
                (widget) {
                  if (widget is Image && widget.image is AssetImage) {
                    final assetImage = widget.image as AssetImage;
                    return assetImage.assetName ==
                        'packages/top_dash_ui/assets/images/card_frames/card_$suitName.png';
                  }
                  return false;
                },
              ),
              findsOneWidget,
            );

            expect(
              find.text('1'),
              findsNWidgets(2), // Two texts are stacked to draw the border.
            );
          });
        });
      });
    }

    testWidgets('breaks when rendering an unknown suit', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          const Directionality(
            textDirection: TextDirection.ltr,
            child: GameCard(
              image: 'image',
              name: 'name',
              description: 'description',
              suitName: '',
              power: 1,
            ),
          ),
        );

        expect(tester.takeException(), isArgumentError);
      });
    });

    testWidgets('renders an overlay', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          const Directionality(
            textDirection: TextDirection.ltr,
            child: GameCard(
              image: 'image',
              name: 'name',
              description: 'description',
              suitName: 'air',
              power: 1,
              overlay: CardOverlayType.win,
            ),
          ),
        );

        expect(find.byType(CardOverlay), findsOneWidget);
      });
    });
  });

  group('GameCardSize', () {
    test('can be instantiated', () {
      expect(GameCardSize.xxs(), isNotNull);
      expect(GameCardSize.xs(), isNotNull);
      expect(GameCardSize.sm(), isNotNull);
      expect(GameCardSize.md(), isNotNull);
      expect(GameCardSize.lg(), isNotNull);
      expect(GameCardSize.xl(), isNotNull);
      expect(GameCardSize.xxl(), isNotNull);
    });
  });
}
