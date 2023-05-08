import 'package:flame/cache.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip/draft/draft.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockImages extends Mock implements Images {}

void main() {
  group('DeckPack', () {
    const child = SizedBox(key: Key('child'));
    const size = Size.square(200);
    late Images images;
    late bool complete;
    void onComplete() => complete = true;

    setUp(() async {
      complete = false;
      images = _MockImages();
      final image = await createTestImage();

      when(() => images.load(any())).thenAnswer((_) async => image);
    });

    Widget buildSubject({bool isAndroid = false}) => DeckPack(
          onComplete: onComplete,
          size: size,
          child: child,
          deviceInfoAware: ({
            required ValueGetter<Widget> asset,
            required ValueGetter<Widget> orElse,
            required DeviceInfoPredicate predicate,
          }) async =>
              isAndroid ? asset() : orElse(),
        );

    group('on android phones', () {
      testWidgets('shows AnimatedDeckPack', (tester) async {
        await tester.pumpApp(
          buildSubject(isAndroid: true),
          images: Images(prefix: ''),
        );
        await tester.pump();

        expect(find.byType(AnimatedDeckPack), findsOneWidget);
      });

      testWidgets('shows child after 0.95 seconds', (tester) async {
        await tester.pumpApp(
          buildSubject(isAndroid: true),
          images: Images(prefix: ''),
        );
        await tester.pump();

        await tester.pump(const Duration(milliseconds: 951));

        expect(find.byWidget(child), findsOneWidget);
      });

      testWidgets('shows child after completing animation', (tester) async {
        await tester.pumpApp(
          buildSubject(isAndroid: true),
          images: Images(prefix: ''),
        );
        await tester.pump();
        await tester.pumpAndSettle();

        expect(find.byWidget(child), findsOneWidget);
        expect(find.byType(AnimatedDeckPack), findsNothing);
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
        await tester.pumpApp(
          buildSubject(),
          images: images,
        );
        await tester.pump();

        final state = tester.state<SpriteAnimationDeckPackState>(
          find.byType(SpriteAnimationDeckPack),
        );
        await state.setupAnimation();
        state.onFrame(29);
        await tester.pump();

        expect(find.byWidget(child), findsOneWidget);
        expect(find.byType(SpriteAnimationWidget), findsOneWidget);
      });

      testWidgets('shows child after completing animation', (tester) async {
        await tester.pumpApp(
          buildSubject(),
          images: images,
        );
        await tester.pump();

        tester
            .widget<SpriteAnimationDeckPack>(
              find.byType(SpriteAnimationDeckPack),
            )
            .onComplete();
        await tester.pump();

        expect(find.byWidget(child), findsOneWidget);
        expect(find.byType(SpriteAnimationWidget), findsNothing);
        expect(find.byType(SpriteAnimationDeckPack), findsNothing);
        expect(complete, isTrue);
      });
    });
  });
}
