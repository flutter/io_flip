import 'package:flame/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/draft/draft.dart';

import '../../helpers/helpers.dart';

void main() {
  group('DeckPack', () {
    const child = SizedBox(key: Key('child'));
    const anim = SizedBox(key: Key('anim'));
    const size = Size.square(200);
    late bool complete;
    void onComplete() => complete = true;

    setUp(() {
      complete = false;
    });

    Widget buildSubject() => DeckPack(
          onComplete: onComplete,
          size: size,
          child: child,
        );

    testWidgets('shows child after frame 29', (tester) async {
      await tester.pumpApp(
        buildSubject(),
        images: Images(prefix: ''),
      );
      await tester.pump();

      tester.state<DeckPackState>(find.byType(DeckPack))
        ..anim = anim
        ..onFrame(29);
      await tester.pump();

      expect(find.byWidget(child), findsOneWidget);
      expect(find.byWidget(anim), findsOneWidget);
    });

    testWidgets('shows child after completing animation', (tester) async {
      await tester.pumpApp(
        buildSubject(),
        images: Images(prefix: ''),
      );
      await tester.pump();

      tester.state<DeckPackState>(find.byType(DeckPack))
        ..anim = anim
        ..onComplete();
      await tester.pump();

      expect(find.byWidget(child), findsOneWidget);
      expect(find.byWidget(anim), findsOneWidget);
      expect(complete, isTrue);
    });
  });
}
