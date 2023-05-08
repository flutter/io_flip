import 'package:flame/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip/prompt/prompt.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  group('CardMaster', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpSubject();
      await tester.pumpAndSettle();
      expect(find.byType(CardMaster), findsOneWidget);
    });

    testWidgets(
      'render sprite animation when is newer androids',
      (tester) async {
        await tester.pumpSubject();
        await tester.pumpAndSettle();
        expect(find.byType(SpriteAnimationWidget), findsOneWidget);
      },
    );

    testWidgets(
      "Don't render the animation when is older androids",
      (tester) async {
        await tester.pumpSubject(isAndroid: true);
        await tester.pumpAndSettle();
        expect(find.byType(SpriteAnimationWidget), findsNothing);
      },
    );
  });
}

extension CardMasterTest on WidgetTester {
  Future<void> pumpSubject({
    bool isAndroid = false,
    bool isDesktop = false,
  }) async {
    Future<String> deviceInfoAwareAsset({
      required bool Function(DeviceInfo deviceInfo) predicate,
      required String Function() asset,
      required String Function() orElse,
    }) async {
      if (isAndroid) {
        return asset();
      } else {
        return orElse();
      }
    }

    await pumpApp(
      CardMaster(deviceInfoAwareAsset: deviceInfoAwareAsset),
    );
  }
}
