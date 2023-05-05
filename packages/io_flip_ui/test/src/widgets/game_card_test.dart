// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../helpers/mock_failed_network_image.dart';

void main() {
  group('GameCard', () {
    for (final suitName in ['fire', 'air', 'earth', 'water', 'metal']) {
      group('when is a $suitName card', () {
        testWidgets('renders correctly', (tester) async {
          await tester.pumpWidget(
            mockNetworkImages(
              () => Directionality(
                textDirection: TextDirection.ltr,
                child: GameCard(
                  image: 'image',
                  name: 'name',
                  description: 'description',
                  suitName: suitName,
                  power: 1,
                  isRare: false,
                ),
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
                      'packages/io_flip_ui/assets/images/card_frames/card_$suitName.png';
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
    }

    testWidgets(
      'renders IO flip game as a placeholder when loading fails',
      (tester) async {
        await tester.pumpWidget(
          mockFailedNetworkImages(
            () => Directionality(
              textDirection: TextDirection.ltr,
              child: GameCard(
                image: 'image',
                name: 'name',
                description: 'description',
                suitName: 'air',
                power: 1,
                isRare: false,
              ),
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(IoFlipLogo), findsOneWidget);
      },
    );

    testWidgets('breaks when rendering an unknown suit', (tester) async {
      await tester.pumpWidget(
        mockNetworkImages(
          () => const Directionality(
            textDirection: TextDirection.ltr,
            child: GameCard(
              image: 'image',
              name: 'name',
              description: 'description',
              suitName: '',
              power: 1,
              isRare: false,
            ),
          ),
        ),
      );

      expect(tester.takeException(), isArgumentError);
    });

    testWidgets('renders an overlay', (tester) async {
      await tester.pumpWidget(
        mockNetworkImages(
          () => const Directionality(
            textDirection: TextDirection.ltr,
            child: GameCard(
              image: 'image',
              name: 'name',
              description: 'description',
              suitName: 'air',
              power: 1,
              overlay: CardOverlayType.win,
              isRare: false,
            ),
          ),
        ),
      );

      expect(find.byType(CardOverlay), findsOneWidget);
    });

    testWidgets('renders FoilShader when card is rare', (tester) async {
      await tester.pumpWidget(
        mockNetworkImages(
          () => const Directionality(
            textDirection: TextDirection.ltr,
            child: GameCard(
              package: null,
              image: 'image',
              name: 'name',
              description: 'description',
              suitName: 'air',
              power: 1,
              isRare: true,
            ),
          ),
        ),
      );

      expect(find.byType(FoilShader), findsOneWidget);
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

    group('lerp', () {
      const a = GameCardSize.xs();
      const b = GameCardSize.lg();

      test('with t = 0', () {
        final result = GameCardSize.lerp(a, b, 0);

        expect(result, a);
      });

      test('with t = 1', () {
        final result = GameCardSize.lerp(a, b, 1);

        expect(result, b);
      });

      for (var i = 1; i < 10; i += 1) {
        final t = i / 10;

        test('with t = $t', () {
          final result = GameCardSize.lerp(a, b, t)!;

          expect(result.size, equals(Size.lerp(a.size, b.size, t)));
          expect(
            result.imageInset,
            equals(RelativeRect.lerp(a.imageInset, b.imageInset, t)),
          );
          expect(
            result.badgeSize,
            equals(Size.lerp(a.badgeSize, b.badgeSize, t)),
          );
          expect(
            result.titleTextStyle,
            equals(
              TextStyle.lerp(
                a.titleTextStyle,
                b.titleTextStyle,
                t,
              ),
            ),
          );
          expect(
            result.descriptionTextStyle,
            equals(
              TextStyle.lerp(
                a.descriptionTextStyle,
                b.descriptionTextStyle,
                t,
              ),
            ),
          );
          expect(
            result.powerTextStyle,
            equals(
              TextStyle.lerp(
                a.powerTextStyle,
                b.powerTextStyle,
                t,
              ),
            ),
          );
          expect(
            result.powerTextStrokeWidth,
            equals(
              lerpDouble(a.powerTextStrokeWidth, b.powerTextStrokeWidth, t),
            ),
          );
        });
      }
    });
  });
}
