// ignore_for_file: prefer_const_constructors

import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:connection_repository/connection_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/app/app.dart';
import 'package:top_dash/audio/audio_controller.dart';
import 'package:top_dash/connection/connection.dart';
import 'package:top_dash/gen/assets.gen.dart';
import 'package:top_dash/how_to_play/how_to_play.dart';
import 'package:top_dash/info/info.dart';
import 'package:top_dash/main_menu/main_menu_screen.dart';
import 'package:top_dash/prompt/prompt.dart';
import 'package:top_dash/settings/persistence/persistence.dart';
import 'package:top_dash/settings/settings.dart';
import 'package:top_dash/style/snack_bar.dart';
import 'package:top_dash/terms_of_use/terms_of_use.dart';

import '../../helpers/helpers.dart';

class _MockBuildContext extends Mock implements BuildContext {}

class _MockAudioController extends Mock implements AudioController {}

class _MockSettingsController extends Mock implements SettingsController {}

class _MockLifecycleNotifier extends Mock
    implements ValueNotifier<AppLifecycleState> {}

class _MockApiClient extends Mock implements ApiClient {}

class _MockGameResource extends Mock implements GameResource {}

class _MockShareResource extends Mock implements ShareResource {}

class _MockScriptsResource extends Mock implements ScriptsResource {}

class _MockPromptResource extends Mock implements PromptResource {}

class _MockLeaderboardResource extends Mock implements LeaderboardResource {}

class _MockMatchMakerRepository extends Mock implements MatchMakerRepository {}

class _MockConnectionRepository extends Mock implements ConnectionRepository {
  _MockConnectionRepository() {
    when(connect).thenAnswer((_) async {});
    when(() => messages).thenAnswer((_) => const Stream.empty());
  }
}

class _MockTermsOfUseCubit extends MockCubit<bool> implements TermsOfUseCubit {}

class _MockMatchSolver extends Mock implements MatchSolver {}

class _MockGameScriptEngine extends Mock implements GameScriptMachine {}

class _MockUser extends Mock implements User {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(PromptTermType.characterClass);
  });

  group('App', () {
    late ApiClient apiClient;

    setUp(() {
      apiClient = _MockApiClient();
      when(() => apiClient.gameResource).thenReturn(_MockGameResource());
      when(() => apiClient.shareResource).thenReturn(_MockShareResource());

      final promptResource = _MockPromptResource();
      when(() => promptResource.getPromptTerms(any()))
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
          connectionRepository: _MockConnectionRepository(),
          matchSolver: _MockMatchSolver(),
          gameScriptMachine: _MockGameScriptEngine(),
          user: _MockUser(),
          isScriptsEnabled: true,
        ),
      );

      showSnackBar('SnackBar');

      await tester.pumpAndSettle();

      expect(find.text('SnackBar'), findsOneWidget);
    });

    testWidgets('wraps everything in a ConnectionOverlay', (tester) async {
      await tester.pumpWidget(
        App(
          settingsPersistence: MemoryOnlySettingsPersistence(),
          apiClient: apiClient,
          matchMakerRepository: _MockMatchMakerRepository(),
          connectionRepository: _MockConnectionRepository(),
          matchSolver: _MockMatchSolver(),
          gameScriptMachine: _MockGameScriptEngine(),
          user: _MockUser(),
          isScriptsEnabled: true,
        ),
      );

      expect(find.byType(ConnectionOverlay), findsOneWidget);
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

    testWidgets('renders the app', (tester) async {
      tester.setLandscapeDisplaySize();
      await tester.pumpWidget(
        App(
          settingsPersistence: MemoryOnlySettingsPersistence(),
          apiClient: apiClient,
          matchMakerRepository: _MockMatchMakerRepository(),
          connectionRepository: _MockConnectionRepository(),
          matchSolver: _MockMatchSolver(),
          gameScriptMachine: _MockGameScriptEngine(),
          user: _MockUser(),
          isScriptsEnabled: true,
        ),
      );

      expect(find.byType(MainMenuScreen), findsOneWidget);
    });

    testWidgets(
      'shows terms of use dialog when terms have not been accepted',
      (tester) async {
        final mockCubit = _MockTermsOfUseCubit();
        when(() => mockCubit.state).thenReturn(false);

        await tester.pumpWidget(
          App(
            settingsPersistence: MemoryOnlySettingsPersistence(),
            apiClient: apiClient,
            matchMakerRepository: _MockMatchMakerRepository(),
            connectionRepository: _MockConnectionRepository(),
            matchSolver: _MockMatchSolver(),
            gameScriptMachine: _MockGameScriptEngine(),
            user: _MockUser(),
            termsOfUseCubit: mockCubit,
            isScriptsEnabled: true,
          ),
        );

        await tester.tap(find.text(tester.l10n.play));
        await tester.pumpAndSettle();

        expect(find.byType(TermsOfUseView), findsOneWidget);
      },
    );

    testWidgets(
      'navigates to the prompt page when TermsOfUseCubit state changes '
      'from false to true',
      (tester) async {
        final mockCubit = _MockTermsOfUseCubit();

        whenListen(
          mockCubit,
          Stream.fromIterable([false, true]),
          initialState: false,
        );

        await tester.pumpWidget(
          App(
            settingsPersistence: MemoryOnlySettingsPersistence(),
            apiClient: apiClient,
            matchMakerRepository: _MockMatchMakerRepository(),
            connectionRepository: _MockConnectionRepository(),
            matchSolver: _MockMatchSolver(),
            gameScriptMachine: _MockGameScriptEngine(),
            user: _MockUser(),
            termsOfUseCubit: mockCubit,
            isScriptsEnabled: true,
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(PromptPage), findsOneWidget);
      },
    );

    testWidgets(
      'navigates to the prompt page when terms are accepted',
      (tester) async {
        final mockCubit = _MockTermsOfUseCubit();
        when(() => mockCubit.state).thenReturn(true);

        await tester.pumpWidget(
          App(
            settingsPersistence: MemoryOnlySettingsPersistence(),
            apiClient: apiClient,
            matchMakerRepository: _MockMatchMakerRepository(),
            connectionRepository: _MockConnectionRepository(),
            matchSolver: _MockMatchSolver(),
            gameScriptMachine: _MockGameScriptEngine(),
            user: _MockUser(),
            termsOfUseCubit: mockCubit,
            isScriptsEnabled: true,
          ),
        );

        await tester.tap(find.text(tester.l10n.play));
        await tester.pumpAndSettle();

        expect(find.byType(PromptPage), findsOneWidget);
      },
    );

    testWidgets('can navigate to the info view', (tester) async {
      await tester.pumpWidget(
        App(
          settingsPersistence: MemoryOnlySettingsPersistence(),
          apiClient: apiClient,
          matchMakerRepository: _MockMatchMakerRepository(),
          connectionRepository: _MockConnectionRepository(),
          matchSolver: _MockMatchSolver(),
          gameScriptMachine: _MockGameScriptEngine(),
          user: _MockUser(),
          isScriptsEnabled: true,
        ),
      );

      await tester.tap(find.byKey(const Key('info_button')));
      await tester.pumpAndSettle();

      expect(find.byType(InfoView), findsOneWidget);
    });

    testWidgets('can navigate to the how to play page', (tester) async {
      await tester.pumpWidget(
        App(
          settingsPersistence: MemoryOnlySettingsPersistence(),
          apiClient: apiClient,
          matchMakerRepository: _MockMatchMakerRepository(),
          connectionRepository: _MockConnectionRepository(),
          matchSolver: _MockMatchSolver(),
          gameScriptMachine: _MockGameScriptEngine(),
          user: _MockUser(),
          isScriptsEnabled: true,
        ),
      );

      await tester.tap(find.byIcon(Icons.question_mark_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(HowToPlayDialog), findsOneWidget);
    });

    testWidgets('plays a button click when a button is played', (tester) async {
      final audioController = _MockAudioController();
      when(audioController.initialize).thenAnswer((_) async {});
      when(() => audioController.playSfx(any())).thenAnswer((_) async {});
      await tester.pumpWidget(
        App(
          settingsPersistence: MemoryOnlySettingsPersistence(),
          apiClient: apiClient,
          matchMakerRepository: _MockMatchMakerRepository(),
          connectionRepository: _MockConnectionRepository(),
          matchSolver: _MockMatchSolver(),
          gameScriptMachine: _MockGameScriptEngine(),
          audioController: audioController,
          user: _MockUser(),
          isScriptsEnabled: true,
        ),
      );

      await tester.tap(find.text(tester.l10n.play));
      await tester.pumpAndSettle();

      verify(() => audioController.playSfx(Assets.sfx.click)).called(1);
    });

    testWidgets('shows info popup', (tester) async {
      final audioController = _MockAudioController();
      when(audioController.initialize).thenAnswer((_) async {});
      when(() => audioController.playSfx(any())).thenAnswer((_) async {});
      await tester.pumpWidget(
        App(
          settingsPersistence: MemoryOnlySettingsPersistence(),
          apiClient: apiClient,
          matchMakerRepository: _MockMatchMakerRepository(),
          connectionRepository: _MockConnectionRepository(),
          matchSolver: _MockMatchSolver(),
          gameScriptMachine: _MockGameScriptEngine(),
          audioController: audioController,
          user: _MockUser(),
          isScriptsEnabled: true,
        ),
      );

      await tester.tap(find.byKey(Key('info_button')));
      await tester.pumpAndSettle();

      // TODO(jaime): change verification when info popup created
      verify(() => audioController.playSfx(Assets.sfx.click)).called(1);
    });
  });
}
