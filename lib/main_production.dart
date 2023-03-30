import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_script_machine/game_script_machine.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:top_dash/app/app.dart';
import 'package:top_dash/bootstrap.dart';
import 'package:top_dash/firebase_options_development.dart';
import 'package:top_dash/settings/persistence/persistence.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  unawaited(
    bootstrap(
      (firestore, firebaseAuth) async {
        final authenticationRepository = AuthenticationRepository(
          firebaseAuth: firebaseAuth,
        );

        final apiClient = ApiClient(
          baseUrl: 'https://top-dash-dev-api-synvj3dcmq-uc.a.run.app',
          idTokenStream: authenticationRepository.idToken,
          refreshIdToken: authenticationRepository.refreshIdToken,
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
          matchSolver: MatchSolver(gameScriptMachine: gameScriptMachine),
          gameScriptMachine: gameScriptMachine,
          user: await authenticationRepository.user.first,
        );
      },
    ),
  );
}
