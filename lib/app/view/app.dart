import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:go_router/go_router.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:provider/provider.dart';
import 'package:top_dash/app_lifecycle/app_lifecycle.dart';
import 'package:top_dash/audio/audio_controller.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/router/router.dart';
import 'package:top_dash/settings/persistence/persistence.dart';
import 'package:top_dash/settings/settings.dart';
import 'package:top_dash/style/snack_bar.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

typedef CreateAudioController = AudioController Function();

@visibleForTesting
AudioController updateAudioController(
  BuildContext context,
  SettingsController settings,
  ValueNotifier<AppLifecycleState> lifecycleNotifier,
  AudioController? audio, {
  CreateAudioController createAudioController = AudioController.new,
}) {
  return audio ?? createAudioController()
    ..initialize()
    ..attachSettings(settings)
    ..attachLifecycleNotifier(lifecycleNotifier);
}

class App extends StatefulWidget {
  const App({
    required this.settingsPersistence,
    required this.apiClient,
    required this.matchMakerRepository,
    required this.matchSolver,
    required this.gameScriptMachine,
    required this.user,
    this.router,
    super.key,
  });

  final SettingsPersistence settingsPersistence;
  final ApiClient apiClient;
  final MatchMakerRepository matchMakerRepository;
  final MatchSolver matchSolver;
  final GameScriptMachine gameScriptMachine;
  final User user;
  final GoRouter? router;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final router = widget.router ?? createRouter();

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MultiProvider(
        providers: [
          Provider.value(value: widget.apiClient.gameResource),
          Provider.value(value: widget.apiClient.scriptsResource),
          Provider.value(value: widget.apiClient.leaderboardResource),
          Provider.value(value: widget.matchMakerRepository),
          Provider.value(value: widget.matchSolver),
          Provider.value(value: widget.gameScriptMachine),
          Provider.value(value: widget.user),
          Provider<SettingsController>(
            lazy: false,
            create: (context) => SettingsController(
              persistence: widget.settingsPersistence,
            )..loadStateFromPersistence(),
          ),
          ProxyProvider2<SettingsController, ValueNotifier<AppLifecycleState>,
              AudioController>(
            // Ensures that the AudioController is created on startup,
            // and not "only when it's needed", as is default behavior.
            // This way, music starts immediately.
            lazy: false,
            create: (context) => AudioController()..initialize(),
            update: updateAudioController,
            dispose: (context, audio) => audio.dispose(),
          ),
        ],
        child: Builder(
          builder: (context) {
            return MaterialApp.router(
              title: 'Top Dash',
              theme: TopDashTheme.themeData,
              routeInformationProvider: router.routeInformationProvider,
              routeInformationParser: router.routeInformationParser,
              routerDelegate: router.routerDelegate,
              scaffoldMessengerKey: scaffoldMessengerKey,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            );
          },
        ),
      ),
    );
  }
}
