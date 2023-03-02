import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_client/game_client.dart';
import 'package:match_maker_repository/match_maker_repository.dart';
import 'package:top_dash/app/app.dart';
import 'package:top_dash/bootstrap.dart';
import 'package:top_dash/firebase_options_development.dart';
import 'package:top_dash/settings/persistence/persistence.dart';

void main() {
  const gameClient = GameClient(
    endpoint: 'https://top-dash-dev-api-synvj3dcmq-uc.a.run.app',
  );
  bootstrap(
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
    builder: (FirebaseFirestore firebaseFirestore) => App(
      settingsPersistence: LocalStorageSettingsPersistence(),
      gameClient: gameClient,
      matchMakerRepository: MatchMakerRepository(db: firebaseFirestore),
    ),
  );
}
