import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:connection_repository/connection_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flame/cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:go_router/go_router.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:top_dash/audio/audio_controller.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/settings/settings.dart';
import 'package:top_dash/style/snack_bar.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

import 'helpers.dart';

class _MockSettingsController extends Mock implements SettingsController {}

class _MockGameResource extends Mock implements GameResource {}

class _MockShareResource extends Mock implements ShareResource {}

class _MockPromptResource extends Mock implements PromptResource {}

class _MockScriptsResource extends Mock implements ScriptsResource {}

class _MockLeaderboardResource extends Mock implements LeaderboardResource {}

class _MockMatchMakerRepository extends Mock implements MatchMakerRepository {}

class _MockConnectionRepository extends Mock implements ConnectionRepository {}

class _MockMatchSolver extends Mock implements MatchSolver {}

class _MockGameScriptMachine extends Mock implements GameScriptMachine {}

class _MockAudioController extends Mock implements AudioController {}

class _MockUser extends Mock implements User {}

class _MockUISoundAdapter extends Mock implements UISoundAdapter {}

class _MockGoRouter extends Mock implements GoRouter {}

UISoundAdapter _createUISoundAdapter() {
  final adapter = _MockUISoundAdapter();
  when(() => adapter.playButtonSound).thenReturn(() {});
  return adapter;
}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    SettingsController? settingsController,
    GameResource? gameResource,
    ShareResource? shareResource,
    ScriptsResource? scriptsResource,
    PromptResource? promptResource,
    LeaderboardResource? leaderboardResource,
    MatchMakerRepository? matchMakerRepository,
    AudioController? audioController,
    ConnectionRepository? connectionRepository,
    MatchSolver? matchSolver,
    GameScriptMachine? gameScriptMachine,
    UISoundAdapter? uiSoundAdaptater,
    User? user,
    GoRouter? router,
    Images? images,
  }) {
    return pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(
            value: settingsController ?? _MockSettingsController(),
          ),
          Provider.value(
            value: gameResource ?? _MockGameResource(),
          ),
          Provider.value(
            value: shareResource ?? _MockShareResource(),
          ),
          Provider.value(
            value: scriptsResource ?? _MockScriptsResource(),
          ),
          Provider.value(
            value: promptResource ?? _MockPromptResource(),
          ),
          Provider.value(
            value: leaderboardResource ?? _MockLeaderboardResource(),
          ),
          Provider.value(
            value: matchMakerRepository ?? _MockMatchMakerRepository(),
          ),
          Provider.value(
            value: audioController ?? _MockAudioController(),
          ),
          Provider.value(
            value: connectionRepository ?? _MockConnectionRepository(),
          ),
          Provider.value(
            value: matchSolver ?? _MockMatchSolver(),
          ),
          Provider.value(
            value: uiSoundAdaptater ?? _createUISoundAdapter(),
          ),
          Provider.value(
            value: gameScriptMachine ?? _MockGameScriptMachine(),
          ),
          Provider.value(
            value: user ?? _MockUser(),
          ),
          Provider.value(
            value: Images(prefix: ''),
          )
        ],
        child: MockGoRouterProvider(
          goRouter: router ?? _MockGoRouter(),
          child: MaterialApp(
            scaffoldMessengerKey: scaffoldMessengerKey,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: widget,
          ),
        ),
      ),
    );
  }
}

extension PumpAppWithRouter on WidgetTester {
  Future<void> pumpAppWithRouter<T extends Bloc<Equatable, Equatable>>(
    GoRouter router, {
    SettingsController? settingsController,
    GameResource? gameResource,
    ShareResource? shareResource,
    PromptResource? promptResource,
    ScriptsResource? scriptsResource,
    LeaderboardResource? leaderboardResource,
    MatchMakerRepository? matchMakerRepository,
    MatchSolver? matchSolver,
    GameScriptMachine? gameScriptMachine,
    AudioController? audioController,
    User? user,
    T? bloc,
  }) {
    return pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(
            value: settingsController ?? _MockSettingsController(),
          ),
          Provider.value(
            value: promptResource ?? _MockPromptResource(),
          ),
          Provider.value(
            value: gameResource ?? _MockGameResource(),
          ),
          Provider.value(
            value: shareResource ?? _MockShareResource(),
          ),
          Provider.value(
            value: scriptsResource ?? _MockScriptsResource(),
          ),
          Provider.value(
            value: leaderboardResource ?? _MockLeaderboardResource(),
          ),
          Provider.value(
            value: matchMakerRepository ?? _MockMatchMakerRepository(),
          ),
          Provider.value(
            value: matchSolver ?? _MockMatchSolver(),
          ),
          Provider.value(
            value: gameScriptMachine ?? _MockGameScriptMachine(),
          ),
          Provider.value(
            value: audioController ?? _MockAudioController(),
          ),
          Provider.value(
            value: user ?? _MockUser(),
          ),
        ],
        child: bloc != null
            ? BlocProvider.value(
                value: bloc,
                child: MaterialApp.router(
                  scaffoldMessengerKey: scaffoldMessengerKey,
                  routeInformationProvider: router.routeInformationProvider,
                  routeInformationParser: router.routeInformationParser,
                  routerDelegate: router.routerDelegate,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                ),
              )
            : MaterialApp.router(
                scaffoldMessengerKey: scaffoldMessengerKey,
                routeInformationProvider: router.routeInformationProvider,
                routeInformationParser: router.routeInformationParser,
                routerDelegate: router.routerDelegate,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
              ),
      ),
    );
  }
}
