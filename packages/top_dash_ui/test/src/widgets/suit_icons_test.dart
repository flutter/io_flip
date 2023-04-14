import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash_ui/gen/assets.gen.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

void main() {
  group('SuitIcons', () {
    test('use their corresponding asset', () {
      expect(SuitIcon.fire().asset, equals(Assets.images.suits.fire));
      expect(SuitIcon.air().asset, equals(Assets.images.suits.air));
      expect(SuitIcon.metal().asset, equals(Assets.images.suits.metal));
      expect(SuitIcon.earth().asset, equals(Assets.images.suits.earth));
      expect(SuitIcon.water().asset, equals(Assets.images.suits.water));
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
