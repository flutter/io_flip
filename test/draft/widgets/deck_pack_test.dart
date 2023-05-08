import 'package:flame/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip/draft/draft.dart';
import 'package:io_flip/utils/platform_aware_asset.dart';

import '../../helpers/helpers.dart';

void main() {
  group('DeckPack', () {
    const child = SizedBox(key: Key('child'));
    const size = Size.square(200);
    late bool complete;
    void onComplete() => complete = true;

    setUp(() {
      complete = false;
    });

    Widget buildSubject({bool isOlderAndroid = false}) => DeckPack(
          onComplete: onComplete,
          size: size,
          child: child,
          deviceInfoAware: ({
            required ValueGetter<Widget> asset,
            required ValueGetter<Widget> orElse,
            required DeviceInfoPredicate predicate,
          }) async =>
              isOlderAndroid ? asset() : orElse(),
        );

    group('on older android phones', () {
      testWidgets('shows AnimatedDeckPack', (tester) async {
        await tester.pumpApp(
          buildSubject(isOlderAndroid: true),
          images: Images(prefix: ''),
        );
        await tester.pump();

        expect(find.byType(AnimatedDeckPack), findsOneWidget);
      });

      testWidgets('shows child after 0.95 seconds', (tester) async {
        await tester.pumpApp(
          buildSubject(isOlderAndroid: true),
          images: Images(prefix: ''),
        );
        await tester.pump();

        await tester.pump(const Duration(milliseconds: 951));

        expect(find.byWidget(child), findsOneWidget);
      });

      testWidgets('shows child after completing animation', (tester) async {
        await tester.pumpApp(
          buildSubject(isOlderAndroid: true),
          images: Images(prefix: ''),
        );
        await tester.pump();
        await tester.pumpAndSettle();

        expect(find.byWidget(child), findsOneWidget);
        expect(complete, isTrue);
      });
    });

    group('on desktop and newer phones', () {
      testWidgets('shows SpriteAnimationDeckPack', (tester) async {
        await tester.pumpApp(
          buildSubject(),
          images: Images(prefix: ''),
        );
        await tester.pump();
        expect(find.byType(SpriteAnimationDeckPack), findsOneWidget);
      });

      testWidgets('shows child after frame 29', (tester) async {
        final images = Images(prefix: '');
        await tester.pumpApp(
          buildSubject(),
          images: images,
        );
        await tester.pump();

        tester
            .state<SpriteAnimationDeckPackState>(
              find.byType(SpriteAnimationDeckPack),
            )
            .onFrame(29);
        await tester.pump();

        expect(find.byWidget(child), findsOneWidget);
      });

      testWidgets('shows child after completing animation', (tester) async {
        await tester.pumpApp(
          buildSubject(),
          images: Images(prefix: ''),
        );
        await tester.pump();

        tester
            .widget<SpriteAnimationDeckPack>(
              find.byType(SpriteAnimationDeckPack),
            )
            .onComplete();
        await tester.pump();

        expect(find.byWidget(child), findsOneWidget);
        expect(complete, isTrue);
      });
    });
  });
}
