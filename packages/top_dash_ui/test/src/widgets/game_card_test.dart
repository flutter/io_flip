import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

void main() {
  group('GameCard', () {
    testWidgets('renders correctly', (tester) async {
      await mockNetworkImages(() async {
        const width = 1200.0;
        const height = 800.0;
        await tester.pumpWidget(
          const Directionality(
            textDirection: TextDirection.ltr,
            child: GameCard(
              width: width,
              height: height,
              image: 'image',
              name: 'name',
              suitName: 'suitName',
              power: 1,
            ),
          ),
        );

        expect(
          find.text('name'),
          findsOneWidget,
        );
        expect(
          find.text('suitName'),
          findsOneWidget,
        );
        expect(
          find.text('1'),
          findsOneWidget,
        );
      });
    });
  });
}
