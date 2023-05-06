import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

void main() {
  group('AnimatedCard', () {
    late AnimatedCardController controller;
    const front = Text('front');
    const back = Text('back');

    setUp(() {
      controller = AnimatedCardController();
    });

    tearDown(() {
      controller.dispose();
    });

    Widget buildSubject() => MaterialApp(
          home: Scaffold(
            body: Center(
              child: AnimatedCard(
                front: front,
                back: back,
                controller: controller,
              ),
            ),
          ),
        );

    testWidgets('displays front by default', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.byWidget(front), findsOneWidget);
      expect(find.byWidget(back), findsNothing);
    });

    testWidgets('displays back when flipped', (tester) async {
      await tester.pumpWidget(buildSubject());

      unawaited(controller.run(smallFlipAnimation));
      await tester.pumpAndSettle();

      expect(find.byWidget(front), findsNothing);
      expect(find.byWidget(back), findsOneWidget);
    });

    testWidgets('displays front when flipped back', (tester) async {
      await tester.pumpWidget(buildSubject());

      unawaited(controller.run(smallFlipAnimation));
      await tester.pumpAndSettle();

      unawaited(controller.run(smallFlipAnimation));
      await tester.pumpAndSettle();

      expect(find.byWidget(front), findsOneWidget);
      expect(find.byWidget(back), findsNothing);
    });

    testWidgets(
      'displays front when flipped back partially through',
      (tester) async {
        await tester.pumpWidget(buildSubject());

        unawaited(controller.run(smallFlipAnimation));
        await tester.pump(smallFlipAnimation.duration ~/ 2);

        unawaited(controller.run(smallFlipAnimation));
        await tester.pumpAndSettle();

        expect(find.byWidget(front), findsOneWidget);
        expect(find.byWidget(back), findsNothing);
      },
    );

    group('card animations', () {
      testWidgets('can run smallFlipAnimation', (tester) async {
        await tester.pumpWidget(buildSubject());

        unawaited(controller.run(smallFlipAnimation));
        await tester.pumpAndSettle();

        expect(find.byWidget(front), findsNothing);
        expect(find.byWidget(back), findsOneWidget);
      });

      testWidgets('can run bigFlipAnimation', (tester) async {
        await tester.pumpWidget(buildSubject());

        unawaited(controller.run(bigFlipAnimation));
        await tester.pumpAndSettle();

        expect(find.byWidget(front), findsNothing);
        expect(find.byWidget(back), findsOneWidget);
      });

      testWidgets('can run jumpAnimation', (tester) async {
        await tester.pumpWidget(buildSubject());

        unawaited(controller.run(jumpAnimation));
        await tester.pumpAndSettle();

        expect(find.byWidget(front), findsOneWidget);
        expect(find.byWidget(back), findsNothing);
      });

      testWidgets('can run opponentKnockOutAnimation', (tester) async {
        await tester.pumpWidget(buildSubject());

        unawaited(controller.run(opponentKnockOutAnimation));
        await tester.pumpAndSettle();

        expect(find.byWidget(front), findsOneWidget);
        expect(find.byWidget(back), findsNothing);
      });

      testWidgets('can run playerKnockOutAnimation', (tester) async {
        await tester.pumpWidget(buildSubject());

        unawaited(controller.run(playerKnockOutAnimation));
        await tester.pumpAndSettle();

        expect(find.byWidget(front), findsOneWidget);
        expect(find.byWidget(back), findsNothing);
      });

      testWidgets('can run playerAttackForwardAnimation', (tester) async {
        await tester.pumpWidget(buildSubject());

        unawaited(controller.run(playerAttackForwardAnimation));
        await tester.pumpAndSettle();

        expect(find.byWidget(front), findsOneWidget);
        expect(find.byWidget(back), findsNothing);
      });

      testWidgets('can run playerAttackBackAnimation', (tester) async {
        await tester.pumpWidget(buildSubject());

        unawaited(controller.run(playerAttackBackAnimation));
        await tester.pumpAndSettle();

        expect(find.byWidget(front), findsOneWidget);
        expect(find.byWidget(back), findsNothing);
      });

      testWidgets('can run opponentAttackForwardAnimation', (tester) async {
        await tester.pumpWidget(buildSubject());

        unawaited(controller.run(opponentAttackForwardAnimation));
        await tester.pumpAndSettle();

        expect(find.byWidget(front), findsOneWidget);
        expect(find.byWidget(back), findsNothing);
      });

      testWidgets('can run opponentAttackBackAnimation', (tester) async {
        await tester.pumpWidget(buildSubject());

        unawaited(controller.run(opponentAttackBackAnimation));
        await tester.pumpAndSettle();

        expect(find.byWidget(front), findsOneWidget);
        expect(find.byWidget(back), findsNothing);
      });
    });
  });

  group('AnimatedCardController', () {
    test(
      'run returns a complete future when the controller has no state attached',
      () async {
        final controller = AnimatedCardController();

        var isComplete = false;
        unawaited(
          controller
              .run(smallFlipAnimation)
              .whenComplete(() => isComplete = true),
        );

        await Future.microtask(() {});

        expect(isComplete, isTrue);
      },
    );
  });
}
