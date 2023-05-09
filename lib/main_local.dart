// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:js' as js;

import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:config_repository/config_repository.dart';
import 'package:connection_repository/connection_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:io_flip/app/app.dart';
import 'package:io_flip/bootstrap.dart';
import 'package:io_flip/firebase_options_development.dart';
import 'package:io_flip/settings/persistence/persistence.dart';
import 'package:match_maker_repository/match_maker_repository.dart';

void main() async {
  js.context['FIREBASE_APPCHECK_DEBUG_TOKEN'] =
      const String.fromEnvironment('APPCHECK_DEBUG_TOKEN');

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

        try {
          firestore.useFirestoreEmulator('localhost', 8081);
          await firebaseAuth.useAuthEmulator('localhost', 9099);
        } catch (e) {
          debugPrint(e.toString());
        }

        final authenticationRepository = AuthenticationRepository(
          firebaseAuth: firebaseAuth,
        );

        final apiClient = ApiClient(
          baseUrl: 'http://localhost:8080',
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
          configRepository: ConfigRepository(db: firestore),
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
