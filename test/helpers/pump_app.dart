import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:go_router/go_router.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/settings/settings.dart';
import 'package:top_dash/style/snack_bar.dart';

import 'helpers.dart';

class _MockSettingsController extends Mock implements SettingsController {}

class _MockGameResource extends Mock implements GameResource {}

class _MockScriptsResource extends Mock implements ScriptsResource {}

class _MockMatchMakerRepository extends Mock implements MatchMakerRepository {}

class _MockMatchSolver extends Mock implements MatchSolver {}

class _MockGameScriptMachine extends Mock implements GameScriptMachine {}

class _MockUser extends Mock implements User {}

class _MockGoRouter extends Mock implements GoRouter {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    SettingsController? settingsController,
    GameResource? gameResource,
    ScriptsResource? scriptsResource,
    MatchMakerRepository? matchMakerRepository,
    MatchSolver? matchSolver,
    GameScriptMachine? gameScriptMachine,
    User? user,
    GoRouter? router,
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
            value: scriptsResource ?? _MockScriptsResource(),
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
            value: user ?? _MockUser(),
          ),
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
