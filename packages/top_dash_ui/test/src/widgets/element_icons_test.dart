import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash_ui/gen/assets.gen.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

void main() {
  group('ElementIcons', () {
    test('use their corresponding asset', () {
      expect(ElementIcon.fire().asset, equals(Assets.images.elements.fire));
      expect(ElementIcon.air().asset, equals(Assets.images.elements.air));
      expect(ElementIcon.metal().asset, equals(Assets.images.elements.metal));
      expect(ElementIcon.earth().asset, equals(Assets.images.elements.earth));
      expect(ElementIcon.water().asset, equals(Assets.images.elements.water));
    });

    testWidgets('renders size correctly', (tester) async {
      await tester.pumpWidget(ElementIcon.fire(scale: 2));
      expect(
        tester.widget(find.byType(ElementIcon)),
        isA<ElementIcon>().having((i) => i.size, 'size', 192),
      );
    });
  });
}
