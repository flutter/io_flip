import 'package:flutter/material.dart' hide Card;
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:top_dash/share/views/share_card_dialog.dart';
import 'package:top_dash/share/widgets/widgets.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

import '../../helpers/helpers.dart';

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
  group('CardFan', () {
    testWidgets('renders', (tester) async {
      await tester.pumpSubject();
      expect(find.byType(CardFan), findsOneWidget);
    });

    testWidgets('renders a GameCard', (tester) async {
      await tester.pumpSubject();

      expect(find.byType(GameCard), findsNWidgets(3));
    });
  });
}

extension ShareCardDialogTest on WidgetTester {
  Future<void> pumpSubject() async {
    await mockNetworkImages(() {
      return pumpApp(
        Scaffold(
          body: CardFan(),
        ),
      );
    });
  }
}
