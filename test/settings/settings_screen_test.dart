import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/settings/settings.dart';

import '../helpers/helpers.dart';

class _MockSettingsController extends Mock implements SettingsController {}

void main() {
  group('SettingsScreen', () {
    late SettingsController settingsController;
    late GoRouter router;

    setUp(() {
      settingsController = _MockSettingsController();
      router = MockGoRouter();

      when(() => settingsController.soundsOn).thenReturn(ValueNotifier(true));
      when(() => settingsController.toggleSoundsOn()).thenAnswer((_) {});
      when(() => settingsController.musicOn).thenReturn(ValueNotifier(false));
      when(() => settingsController.toggleMusicOn()).thenAnswer((_) {});

      when(() => router.push('/settings/how_to_play'))
          .thenAnswer((_) async => null);
    });

    Future<void> pumpSubjectWith(WidgetTester tester) => tester.pumpApp(
          const SettingsScreen(),
          settingsController: settingsController,
          router: router,
        );

    test('routeBuilder returns a SettingsScreen', () {
      final result = SettingsScreen.routeBuilder(null, null);

      expect(result, isA<SettingsScreen>());
    });

    testWidgets('contains the title', (tester) async {
      await pumpSubjectWith(tester);

      expect(find.text(tester.l10n.settingsPageTitle), findsOneWidget);
    });

    testWidgets('contains the how to play item', (tester) async {
      await pumpSubjectWith(tester);

      expect(find.text(tester.l10n.settingsHowToPlayItem), findsOneWidget);
    });

    testWidgets(
        'tapping the how to play item navigates to the how to play page',
        (tester) async {
      await pumpSubjectWith(tester);

      await tester.tap(find.text(tester.l10n.settingsHowToPlayItem));

      verify(() => router.push('/settings/how_to_play')).called(1);
    });

    testWidgets('contains the sound effects item', (tester) async {
      await pumpSubjectWith(tester);

      expect(find.text(tester.l10n.settingsSoundEffectsItem), findsOneWidget);
    });

    testWidgets('tapping the sound effects item toggles the sounds',
        (tester) async {
      await pumpSubjectWith(tester);

      await tester.tap(find.text(tester.l10n.settingsSoundEffectsItem));

      verify(() => settingsController.toggleSoundsOn()).called(1);
    });

    testWidgets('contains the music item', (tester) async {
      await pumpSubjectWith(tester);

      expect(find.text(tester.l10n.settingsMusicItem), findsOneWidget);
    });

    testWidgets('tapping the music item toggles the music', (tester) async {
      await pumpSubjectWith(tester);

      await tester.tap(find.text(tester.l10n.settingsMusicItem));

      verify(() => settingsController.toggleMusicOn()).called(1);
    });

    testWidgets('contains the credits item', (tester) async {
      await pumpSubjectWith(tester);

      expect(find.text(tester.l10n.settingsCreditsItem), findsOneWidget);
    });
  });
}
