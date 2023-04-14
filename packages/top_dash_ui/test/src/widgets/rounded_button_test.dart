import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

void main() {
  group('RoundedButton', () {
    testWidgets('renders the given icon and responds to taps', (tester) async {
      var wasTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: RoundedButton.icon(
                const Icon(Icons.settings),
                onPressed: () {
                  wasTapped = true;
                },
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byIcon(Icons.settings));
      expect(wasTapped, isTrue);
    });

    testWidgets('renders the given text and responds to taps', (tester) async {
      var wasTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: RoundedButton.text(
                'test',
                onPressed: () {
                  wasTapped = true;
                },
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('test'));
      expect(wasTapped, isTrue);
    });

    testWidgets('renders the given image and label and responds to taps',
        (tester) async {
      final file = File('');
      var wasTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: RoundedButton.image(
                Image.file(file),
                label: 'test',
                onPressed: () {
                  wasTapped = true;
                },
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('test'));
      expect(find.byType(Image), findsOneWidget);
      expect(wasTapped, isTrue);
    });
  });
}
