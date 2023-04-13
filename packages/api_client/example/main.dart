// ignore_for_file: avoid_print

import 'package:api_client/api_client.dart';
import 'package:game_domain/game_domain.dart';

void main() async {
  final client = ApiClient(
    baseUrl: 'https://top-dash-dev-api-synvj3dcmq-uc.a.run.app',
    idTokenStream: const Stream.empty(),
    refreshIdToken: () async => null,
    appCheckTokenStream: const Stream.empty(),
  );

  final cards = await client.gameResource.generateCards(const Prompt());
  print(cards);
}
