import 'package:flame/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip/prompt/prompt.dart';
import 'package:io_flip/utils/utils.dart';

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
        await tester.pumpSubject(isOldAndroid: true);
        await tester.pumpAndSettle();
        expect(find.byType(SpriteAnimationWidget), findsNothing);
      },
    );
  });
}

extension CardMasterTest on WidgetTester {
  Future<void> pumpSubject({
    bool isOldAndroid = false,
    bool isDesktop = false,
  }) async {
    Future<T> deviceInfoAwareAsset<T>({
      required bool Function(DeviceInfo deviceInfo) predicate,
      required T Function() asset,
      required T Function() orElse,
    }) async {
      if (isOldAndroid) {
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
