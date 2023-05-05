import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip_ui/gen/assets.gen.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

void main() {
  group('SuitIcons', () {
    test('use their corresponding asset', () {
      expect(
        SuitIcon.fire().asset,
        equals(Assets.images.suits.onboarding.fire),
      );
      expect(
        SuitIcon.air().asset,
        equals(Assets.images.suits.onboarding.air),
      );
      expect(
        SuitIcon.metal().asset,
        equals(Assets.images.suits.onboarding.metal),
      );
      expect(
        SuitIcon.earth().asset,
        equals(Assets.images.suits.onboarding.earth),
      );
      expect(
        SuitIcon.water().asset,
        equals(Assets.images.suits.onboarding.water),
      );
    });

    testWidgets('renders size correctly', (tester) async {
      await tester.pumpWidget(SuitIcon.fire(scale: 2));
      expect(
        tester.widget(find.byType(SuitIcon)),
        isA<SuitIcon>().having((i) => i.size, 'size', 192),
      );
    });
  });
}
