import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/app/app.dart';
import 'package:top_dash/game/game_screen.dart';
import 'package:top_dash/main_menu/main_menu_screen.dart';
import 'package:top_dash/settings/persistence/persistence.dart';
import 'package:top_dash/settings/settings_screen.dart';
import 'package:top_dash/style/snack_bar.dart';

import '../../helpers/helpers.dart';

void main() {
  group('App', () {
    testWidgets('can show a snackbar', (tester) async {
      await tester.pumpWidget(
        App(
          settingsPersistence: MemoryOnlySettingsPersistence(),
        ),
      );

      showSnackBar('SnackBar');

      await tester.pumpAndSettle();

      expect(find.text('SnackBar'), findsOneWidget);
    });

    group('when in portrait mode', () {
      testWidgets('renders the app', (tester) async {
        tester.setPortraitDisplaySize();
        await tester.pumpWidget(
          App(
            settingsPersistence: MemoryOnlySettingsPersistence(),
          ),
        );

        expect(find.byType(MainMenuScreen), findsOneWidget);
      });

      testWidgets('can navigate to the game page', (tester) async {
        tester.setPortraitDisplaySize();
        await tester.pumpWidget(
          App(
            settingsPersistence: MemoryOnlySettingsPersistence(),
          ),
        );

        await tester.tap(find.text('Play'));
        await tester.pumpAndSettle();

        expect(find.byType(GameScreen), findsOneWidget);
      });

      testWidgets('can navigate to the settings page', (tester) async {
        tester.setPortraitDisplaySize();
        await tester.pumpWidget(
          App(
            settingsPersistence: MemoryOnlySettingsPersistence(),
          ),
        );

        await tester.tap(find.text('Settings'));
        await tester.pumpAndSettle();

        expect(find.byType(SettingsScreen), findsOneWidget);
      });

      testWidgets(
        'can navigate to the settings page and go back',
        (tester) async {
          tester.setPortraitDisplaySize();
          await tester.pumpWidget(
            App(
              settingsPersistence: MemoryOnlySettingsPersistence(),
            ),
          );

          await tester.tap(find.text('Settings'));
          await tester.pumpAndSettle();

          await tester.tap(find.text('Back'));
          await tester.pumpAndSettle();

          expect(find.byType(SettingsScreen), findsNothing);
        },
      );
    });

    group('when in landscape mode', () {
      testWidgets('renders the app', (tester) async {
        tester.setLandspaceDisplaySize();
        await tester.pumpWidget(
          App(
            settingsPersistence: MemoryOnlySettingsPersistence(),
          ),
        );

        expect(find.byType(MainMenuScreen), findsOneWidget);
      });

      testWidgets('can navigate to the game page', (tester) async {
        tester.setLandspaceDisplaySize();

        await tester.pumpWidget(
          App(
            settingsPersistence: MemoryOnlySettingsPersistence(),
          ),
        );

        await tester.tap(find.text('Play'));
        await tester.pumpAndSettle();

        expect(find.byType(GameScreen), findsOneWidget);
      });

      testWidgets('can navigate to the settings page', (tester) async {
        tester.setLandspaceDisplaySize();

        await tester.pumpWidget(
          App(
            settingsPersistence: MemoryOnlySettingsPersistence(),
          ),
        );

        await tester.tap(find.text('Settings'));
        await tester.pumpAndSettle();

        expect(find.byType(SettingsScreen), findsOneWidget);
      });

      testWidgets(
        'can navigate to the settings page and go back',
        (tester) async {
          tester.setLandspaceDisplaySize();

          await tester.pumpWidget(
            App(
              settingsPersistence: MemoryOnlySettingsPersistence(),
            ),
          );

          await tester.tap(find.text('Settings'));
          await tester.pumpAndSettle();

          await tester.tap(find.text('Back'));
          await tester.pumpAndSettle();

          expect(find.byType(SettingsScreen), findsNothing);
        },
      );
    });
  });
}
