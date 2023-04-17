// ignore_for_file: avoid_print, unused_local_variable

import 'package:api_client/api_client.dart';

void main() async {
  const url = 'ws://top-dash-dev-api-synvj3dcmq-uc.a.run.app';
  const localUrl = 'ws://localhost:8080';

  final client = ApiClient(
    baseUrl: localUrl,
    idTokenStream: const Stream.empty(),
    refreshIdToken: () async => null,
    appCheckTokenStream: const Stream.empty(),
  );

  final channel = await client.connect('public/connect');
  channel.messages.listen(print);
}
