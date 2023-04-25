// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:js' as js;

import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:connection_repository/connection_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:top_dash/app/app.dart';
import 'package:top_dash/bootstrap.dart';
import 'package:top_dash/firebase_options_development.dart';
import 'package:top_dash/settings/persistence/persistence.dart';

void main() async {
  if (kDebugMode) {
    js.context['FIREBASE_APPCHECK_DEBUG_TOKEN'] =
        const String.fromEnvironment('APPCHECK_DEBUG_TOKEN');
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  unawaited(
    bootstrap(
      (firestore, firebaseAuth, appCheck) async {
        await appCheck.activate(
          webRecaptchaSiteKey: const String.fromEnvironment('RECAPTCHA_KEY'),
        );
        await appCheck.setTokenAutoRefreshEnabled(true);

        final authenticationRepository = AuthenticationRepository(
          firebaseAuth: firebaseAuth,
        );

        final apiClient = ApiClient(
          baseUrl: 'https://top-dash-dev-staging-synvj3dcmq-uc.a.run.app',
          idTokenStream: authenticationRepository.idToken,
          refreshIdToken: authenticationRepository.refreshIdToken,
          appCheckTokenStream: appCheck.onTokenChange,
          appCheckToken: await appCheck.getToken(),
        );

        await authenticationRepository.signInAnonymously();
        await authenticationRepository.idToken.first;

        final currentScript =
            await apiClient.scriptsResource.getCurrentScript();
        final gameScriptMachine = GameScriptMachine.initialize(currentScript);

        return App(
          settingsPersistence: LocalStorageSettingsPersistence(),
          apiClient: apiClient,
          matchMakerRepository: MatchMakerRepository(db: firestore),
          connectionRepository: ConnectionRepository(apiClient: apiClient),
          matchSolver: MatchSolver(gameScriptMachine: gameScriptMachine),
          gameScriptMachine: gameScriptMachine,
          user: await authenticationRepository.user.first,
          isScriptsEnabled: true,
        );
      },
    ),
  );
}
