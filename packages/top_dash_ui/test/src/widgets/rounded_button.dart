import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

void main() {
  group('RoundedButton', () {
    testWidgets('renders the given child and responds to taps', (tester) async {
      var wasTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: RoundedButton(
                child: const Text('test'),
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
  });
}
