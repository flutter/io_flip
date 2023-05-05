import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:connection_repository/connection_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:io_flip/app/app.dart';
import 'package:io_flip/bootstrap.dart';
import 'package:io_flip/firebase_options_production.dart';
import 'package:io_flip/settings/persistence/persistence.dart';
import 'package:match_maker_repository/match_maker_repository.dart';

void main() async {
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
          baseUrl: 'https://io-flip-api-5eji7gzgvq-uc.a.run.app',
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
          isScriptsEnabled: false,
        );
      },
    ),
  );
}
