import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:top_dash_ui/gen/assets.gen.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

void main() {
  group('RoundedButton', () {
    testWidgets('renders the given icon and responds to taps', (tester) async {
      var wasTapped = false;
      await tester.pumpSubject(
        RoundedButton.icon(
          Icons.settings,
          onPressed: () => wasTapped = true,
        ),
      );
      await tester.tap(find.byIcon(Icons.settings));
      expect(wasTapped, isTrue);
    });

    testWidgets('responds to long press', (tester) async {
      var wasTapped = false;
      await tester.pumpSubject(
        RoundedButton.icon(
          Icons.settings,
          onLongPress: () => wasTapped = true,
        ),
      );
      await tester.longPress(find.byIcon(Icons.settings));
      expect(wasTapped, isTrue);
    });

    testWidgets('cancelling tap animates correctly', (tester) async {
      var wasTapped = false;
      await tester.pumpSubject(
        RoundedButton.icon(
          Icons.settings,
          onPressed: () => wasTapped = true,
        ),
      );
      final state =
          tester.state(find.byType(RoundedButton)) as RoundedButtonState;

      await tester.drag(find.byIcon(Icons.settings), const Offset(0, 100));
      expect(wasTapped, isFalse);
      expect(state.isPressed, isFalse);
    });

    testWidgets('renders the given svg and responds to taps', (tester) async {
      var wasTapped = false;
      await tester.pumpSubject(
        RoundedButton.svg(
          Assets.images.ioFlipLogo,
          onPressed: () => wasTapped = true,
        ),
      );
      await tester.tap(find.byType(SvgPicture));
      expect(wasTapped, isTrue);
    });

    testWidgets('renders the given text and responds to taps', (tester) async {
      var wasTapped = false;
      await tester.pumpSubject(
        RoundedButton.text(
          'test',
          onPressed: () => wasTapped = true,
        ),
      );
      await tester.tap(find.text('test'));
      expect(wasTapped, isTrue);
    });

    testWidgets('plays a sound when tapped', (tester) async {
      var soundPlayed = false;

      await tester.pumpSubject(
        RoundedButton.text(
          'test',
          onPressed: () {},
        ),
        playButtonSound: () => soundPlayed = true,
      );
      await tester.tap(find.text('test'));
      expect(soundPlayed, isTrue);
    });

    testWidgets(
      'no sound is played if no tap handler is attached',
      (tester) async {
        var soundPlayed = false;

        await tester.pumpSubject(
          RoundedButton.text('test'),
          playButtonSound: () => soundPlayed = true,
        );
        await tester.tap(find.text('test'));
        expect(soundPlayed, isFalse);
      },
    );

    testWidgets('renders the given image and label and responds to taps',
        (tester) async {
      final file = File('');
      var wasTapped = false;
      await tester.pumpSubject(
        RoundedButton.image(
          Image.file(file),
          label: 'test',
          onPressed: () {
            wasTapped = true;
          },
        ),
      );
      await tester.tap(find.text('test'));
      expect(find.byType(Image), findsOneWidget);
      expect(wasTapped, isTrue);
    });
  });
}

extension RoundedButtonTest on WidgetTester {
  Future<void> pumpSubject(
    Widget child, {
    void Function()? playButtonSound,
  }) {
    return pumpWidget(
      MaterialApp(
        home: Provider(
          create: (_) => UISoundAdapter(
            playButtonSound: playButtonSound ?? () {},
          ),
          child: Scaffold(
            body: Center(
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
