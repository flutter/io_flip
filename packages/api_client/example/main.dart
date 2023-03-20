// ignore_for_file: avoid_print

import 'package:api_client/api_client.dart';

void main() async {
  final client = ApiClient(
    baseUrl: 'https://top-dash-dev-api-synvj3dcmq-uc.a.run.app',
  );

  final card = await client.gameResource.generateCard();
  print(card.props);
}
