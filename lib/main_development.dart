import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:game_client/game_client.dart';
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
        var endpoint = 'https://top-dash-dev-api-synvj3dcmq-uc.a.run.app';
        if (const bool.hasEnvironment('USE_EMULATORS') && kDebugMode) {
          endpoint = 'http://localhost:8080';
          try {
            firestore.useFirestoreEmulator('localhost', 8081);
            await firebaseAuth.useAuthEmulator('localhost', 9099);
          } catch (e) {
            debugPrint(e.toString());
          }
        }

        final gameClient = GameClient(endpoint: endpoint);

        final authenticationRepository = AuthenticationRepository(
          firebaseAuth: firebaseAuth,
        );
        await authenticationRepository.signInAnonymously();

        return App(
          settingsPersistence: LocalStorageSettingsPersistence(),
          gameClient: gameClient,
          matchMakerRepository: MatchMakerRepository(db: firestore),
        );
      },
    ),
  );
}
