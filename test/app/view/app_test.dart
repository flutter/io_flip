import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/app/app.dart';
import 'package:top_dash/audio/audio_controller.dart';
import 'package:top_dash/how_to_play/how_to_play.dart';
import 'package:top_dash/main_menu/main_menu_screen.dart';
import 'package:top_dash/prompt/prompt.dart';
import 'package:top_dash/settings/persistence/persistence.dart';
import 'package:top_dash/settings/settings.dart';
import 'package:top_dash/share/share.dart';
import 'package:top_dash/style/snack_bar.dart';

import '../../helpers/helpers.dart';

class _MockBuildContext extends Mock implements BuildContext {}

class _MockAudioController extends Mock implements AudioController {}

class _MockSettingsController extends Mock implements SettingsController {}

class _MockLifecycleNotifier extends Mock
    implements ValueNotifier<AppLifecycleState> {}

class _MockApiClient extends Mock implements ApiClient {}

class _MockGameResource extends Mock implements GameResource {}

class _MockScriptsResource extends Mock implements ScriptsResource {}

class _MockPromptResource extends Mock implements PromptResource {}

class _MockLeaderboardResource extends Mock implements LeaderboardResource {}

class _MockMatchMakerRepository extends Mock implements MatchMakerRepository {}

class _MockMatchSolver extends Mock implements MatchSolver {}

class _MockGameScriptEngine extends Mock implements GameScriptMachine {}

class _MockUser extends Mock implements User {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('App', () {
    late ApiClient apiClient;

    setUp(() {
      apiClient = _MockApiClient();
      when(() => apiClient.gameResource).thenReturn(_MockGameResource());

      final promptResource = _MockPromptResource();
      when(promptResource.getPromptWhitelist)
          .thenAnswer((_) async => Future.value(['']));
      when(() => apiClient.promptResource).thenReturn(promptResource);
      when(() => apiClient.scriptsResource).thenReturn(_MockScriptsResource());
      when(() => apiClient.leaderboardResource)
          .thenReturn(_MockLeaderboardResource());
    });

    testWidgets('can show a snackbar', (tester) async {
      await tester.pumpWidget(
        App(
          settingsPersistence: MemoryOnlySettingsPersistence(),
          apiClient: apiClient,
          matchMakerRepository: _MockMatchMakerRepository(),
          matchSolver: _MockMatchSolver(),
          gameScriptMachine: _MockGameScriptEngine(),
          user: _MockUser(),
        ),
      );

      showSnackBar('SnackBar');

      await tester.pumpAndSettle();

      expect(find.text('SnackBar'), findsOneWidget);
    });

    group('updateAudioController', () {
      setUpAll(() {
        registerFallbackValue(_MockSettingsController());
        registerFallbackValue(_MockLifecycleNotifier());
      });

      test('initializes, attach to setting and lifecycle', () {
        final buildContext = _MockBuildContext();
        final settingsController = _MockSettingsController();
        final lifecycle = _MockLifecycleNotifier();
        final audioController = _MockAudioController();

        when(audioController.initialize).thenAnswer((_) async {});
        when(() => audioController.attachSettings(any())).thenAnswer((_) {});
        when(() => audioController.attachLifecycleNotifier(any()))
            .thenAnswer((_) {});

        final result = updateAudioController(
          buildContext,
          settingsController,
          lifecycle,
          audioController,
        );

        verify(() => audioController.attachSettings(any())).called(1);
        verify(() => audioController.attachLifecycleNotifier(any())).called(1);

        expect(result, audioController);
      });

      test('returns a new instance when audio controller is null', () {
        final buildContext = _MockBuildContext();
        final audioController = _MockAudioController();

        when(audioController.initialize).thenAnswer((_) async {});
        when(() => audioController.attachSettings(any())).thenAnswer((_) {});
        when(() => audioController.attachLifecycleNotifier(any()))
            .thenAnswer((_) {});

        final result = updateAudioController(
          buildContext,
          SettingsController(persistence: MemoryOnlySettingsPersistence()),
          ValueNotifier(AppLifecycleState.paused),
          null,
          createAudioController: () => audioController,
        );

        verify(() => audioController.attachSettings(any())).called(1);
        verify(() => audioController.attachLifecycleNotifier(any())).called(1);

        expect(result, audioController);
      });
    });

    testWidgets('renders the app in landscape', (tester) async {
      tester.binding.window.devicePixelRatioTestValue = 1;
      await tester.pumpWidget(
        App(
          settingsPersistence: MemoryOnlySettingsPersistence(),
          apiClient: apiClient,
          matchMakerRepository: _MockMatchMakerRepository(),
          matchSolver: _MockMatchSolver(),
          gameScriptMachine: _MockGameScriptEngine(),
          user: _MockUser(),
        ),
      );
      tester.binding.window.clearDevicePixelRatioTestValue();

      expect(find.byType(MainMenuScreen), findsOneWidget);
      expect(find.byType(LandscapeMenuView), findsOneWidget);
    });

    testWidgets('renders the app in portrait', (tester) async {
      tester.binding.window.devicePixelRatioTestValue = 1;
      tester.binding.window.physicalSizeTestValue = const Size(1200, 1600);
      await tester.pumpWidget(
        App(
          settingsPersistence: MemoryOnlySettingsPersistence(),
          apiClient: apiClient,
          matchMakerRepository: _MockMatchMakerRepository(),
          matchSolver: _MockMatchSolver(),
          gameScriptMachine: _MockGameScriptEngine(),
          user: _MockUser(),
        ),
      );
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();

      expect(find.byType(MainMenuScreen), findsOneWidget);
      expect(find.byType(PortraitMenuView), findsOneWidget);
    });

    testWidgets('can navigate to the game page', (tester) async {
      await tester.pumpWidget(
        App(
          settingsPersistence: MemoryOnlySettingsPersistence(),
          apiClient: apiClient,
          matchMakerRepository: _MockMatchMakerRepository(),
          matchSolver: _MockMatchSolver(),
          gameScriptMachine: _MockGameScriptEngine(),
          user: _MockUser(),
        ),
      );

      await tester.tap(find.text(tester.l10n.play));
      await tester.pumpAndSettle();

      expect(find.byType(PromptPage), findsOneWidget);
    });

    testWidgets('can navigate to the settings', (tester) async {
      await tester.pumpWidget(
        App(
          settingsPersistence: MemoryOnlySettingsPersistence(),
          apiClient: apiClient,
          matchMakerRepository: _MockMatchMakerRepository(),
          matchSolver: _MockMatchSolver(),
          gameScriptMachine: _MockGameScriptEngine(),
          user: _MockUser(),
        ),
      );

      await tester.tap(find.byIcon(Icons.more_horiz_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(SettingsScreen), findsOneWidget);
    });

    testWidgets('can navigate to the how to play page', (tester) async {
      await tester.pumpWidget(
        App(
          settingsPersistence: MemoryOnlySettingsPersistence(),
          apiClient: apiClient,
          matchMakerRepository: _MockMatchMakerRepository(),
          matchSolver: _MockMatchSolver(),
          gameScriptMachine: _MockGameScriptEngine(),
          user: _MockUser(),
        ),
      );

      await tester.tap(find.byIcon(Icons.question_mark_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(HowToPlayPage), findsOneWidget);
    });

    testWidgets('can navigate to the share page', (tester) async {
      await tester.pumpWidget(
        App(
          settingsPersistence: MemoryOnlySettingsPersistence(),
          apiClient: apiClient,
          matchMakerRepository: _MockMatchMakerRepository(),
          matchSolver: _MockMatchSolver(),
          gameScriptMachine: _MockGameScriptEngine(),
          user: _MockUser(),
        ),
      );

      await tester.tap(find.byIcon(Icons.share));
      await tester.pumpAndSettle();

      expect(find.byType(SharePage), findsOneWidget);
    });
  });
}
