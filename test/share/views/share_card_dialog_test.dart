import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:top_dash/share/views/share_card_dialog.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

import '../../helpers/helpers.dart';

const shareUrl = 'https://example.com';
const card = Card(
  id: '',
  name: 'name',
  description: 'description',
  image: '',
  rarity: false,
  power: 1,
  suit: Suit.air,
);

void main() {
  group('ShareCardDialog', () {
    testWidgets('renders a GameCard', (tester) async {
      await tester.pumpSubject();

      expect(find.byType(GameCard), findsOneWidget);
    });
  });
}

extension ShareCardDialogTest on WidgetTester {
  Future<void> pumpSubject() async {
    await mockNetworkImages(() {
      return pumpApp(
        const ShareCardDialog(
          twitterShareUrl: shareUrl,
          facebookShareUrl: shareUrl,
          card: card,
        ),
      );
    });
  }
}
