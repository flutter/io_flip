// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

import '../../helpers/mock_failed_network_image.dart';

void main() {
  group('GameCard', () {
    testWidgets(
      'renders IO flip game as a placeholder when loading fails',
      (tester) async {
        await mockFailedNetworkImages(() async {
          await tester.pumpWidget(
            Directionality(
              textDirection: TextDirection.ltr,
              child: GameCard(
                image: 'image',
                name: 'name',
                description: 'description',
                suitName: 'air',
                power: 1,
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.byType(IoFlipLogo), findsOneWidget);
        });
      },
    );
  });
}
