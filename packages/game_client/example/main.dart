// ignore_for_file: avoid_print

import 'package:game_client/game_client.dart';

void main() async {
  const client = GameClient(
    endpoint: 'https://top-dash-dev-api-synvj3dcmq-uc.a.run.app',
  );

  final card = await client.generateCard();
  print(card.props);
}
