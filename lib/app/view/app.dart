import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:connection_repository/connection_repository.dart';
import 'package:flame/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:go_router/go_router.dart';
import 'package:io_flip/app_lifecycle/app_lifecycle.dart';
import 'package:io_flip/audio/audio_controller.dart';
import 'package:io_flip/connection/connection.dart';
import 'package:io_flip/gen/assets.gen.dart';
import 'package:io_flip/l10n/l10n.dart';
import 'package:io_flip/router/router.dart';
import 'package:io_flip/settings/persistence/persistence.dart';
import 'package:io_flip/settings/settings.dart';
import 'package:io_flip/style/snack_bar.dart';
import 'package:io_flip/terms_of_use/terms_of_use.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:provider/provider.dart';

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
    required this.connectionRepository,
    required this.matchSolver,
    required this.gameScriptMachine,
    required this.user,
    required this.isScriptsEnabled,
    this.router,
    this.audioController,
    this.termsOfUseCubit,
    super.key,
  });

  final SettingsPersistence settingsPersistence;
  final ApiClient apiClient;
  final MatchMakerRepository matchMakerRepository;
  final ConnectionRepository connectionRepository;
  final MatchSolver matchSolver;
  final GameScriptMachine gameScriptMachine;
  final User user;
  final GoRouter? router;
  final AudioController? audioController;
  final bool isScriptsEnabled;
  final TermsOfUseCubit? termsOfUseCubit;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final router = widget.router ??
      createRouter(
        isScriptsEnabled: widget.isScriptsEnabled,
      );

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MultiProvider(
        providers: [
          Provider.value(value: widget.apiClient.gameResource),
          Provider.value(value: widget.apiClient.scriptsResource),
          Provider.value(value: widget.apiClient.promptResource),
          Provider.value(value: widget.apiClient.leaderboardResource),
          Provider.value(value: widget.apiClient.shareResource),
          Provider.value(value: widget.matchMakerRepository),
          Provider.value(value: widget.connectionRepository),
          Provider.value(value: widget.matchSolver),
          Provider.value(value: widget.gameScriptMachine),
          Provider.value(value: widget.user),
          Provider.value(value: Images(prefix: '')),
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
            create: (context) =>
                widget.audioController ?? (AudioController()..initialize()),
            update: updateAudioController,
            dispose: (context, audio) => audio.dispose(),
          ),
          BlocProvider(
            create: (context) => ConnectionBloc(
              connectionRepository: widget.connectionRepository,
            )..add(const ConnectionRequested()),
          ),
          BlocProvider(
            create: (_) => widget.termsOfUseCubit ?? TermsOfUseCubit(),
          )
        ],
        child: Builder(
          builder: (context) {
            return Provider<UISoundAdapter>(
              create: (context) {
                final audio = context.read<AudioController>();
                return UISoundAdapter(
                  playButtonSound: () {
                    audio.playSfx(Assets.sfx.click);
                  },
                );
              },
              child: MaterialApp.router(
                title: context.l10n.ioFlip,
                theme: IoFlipTheme.themeData,
                routerConfig: router,
                scaffoldMessengerKey: scaffoldMessengerKey,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                builder: (context, child) => ConnectionOverlay(child: child),
              ),
            );
          },
        ),
      ),
    );
  }
}
