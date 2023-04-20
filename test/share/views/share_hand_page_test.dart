import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:top_dash/settings/settings.dart';
import 'package:top_dash/share/views/share_card_dialog.dart';
import 'package:top_dash/share/views/views.dart';
import 'package:top_dash/share/widgets/widgets.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

import '../../helpers/helpers.dart';

class _MockSettingsController extends Mock implements SettingsController {}

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
  late SettingsController settingsController;
  setUp(() {
    settingsController = _MockSettingsController();
    when(() => settingsController.musicOn).thenReturn(ValueNotifier(true));
    when(() => settingsController.toggleMusicOn()).thenAnswer((_) {});
  });
  group('ShareHandPage', () {
    testWidgets('renders', (tester) async {
      await tester.pumpSubject(settingsController);
      expect(find.byType(ShareHandPage), findsOneWidget);
    });

    testWidgets('renders a IoFlipLogo widget', (tester) async {
      await tester.pumpSubject(settingsController);
      expect(find.byType(IoFlipLogo), findsOneWidget);
    });

    testWidgets('renders a CardFan widget', (tester) async {
      await tester.pumpSubject(settingsController);
      expect(find.byType(CardFan), findsOneWidget);
    });

    testWidgets('renders the users wins and initials', (tester) async {
      await tester.pumpSubject(settingsController);
      expect(find.text('5 ${tester.l10n.winStreakLabel}'), findsOneWidget);
      expect(find.text('AAA'), findsOneWidget);
    });

    testWidgets('renders the title', (tester) async {
      await tester.pumpSubject(settingsController);
      expect(find.text(tester.l10n.shareTeamTitle), findsOneWidget);
    });

    testWidgets('renders a music button', (tester) async {
      await tester.pumpSubject(settingsController);
      expect(find.byIcon(Icons.volume_up), findsOneWidget);
    });
    testWidgets('renders a music off button when music is off', (tester) async {
      when(() => settingsController.musicOn).thenReturn(ValueNotifier(false));
      await tester.pumpSubject(settingsController);
      expect(find.byIcon(Icons.volume_off), findsOneWidget);
    });

    testWidgets(
      'tapping the music button toggles the music',
      (tester) async {
        await tester.pumpSubject(settingsController);
        await tester.tap(find.byIcon(Icons.volume_up));

        verify(() => settingsController.toggleMusicOn()).called(1);
      },
    );
  });
}

extension ShareCardDialogTest on WidgetTester {
  Future<void> pumpSubject(SettingsController settingsController) async {
    await mockNetworkImages(() {
      return pumpApp(
        const ShareHandPage(
          wins: 5,
          initials: 'AAA',
          deckId: '',
        ),
        settingsController: settingsController,
      );
    });
  }
}
