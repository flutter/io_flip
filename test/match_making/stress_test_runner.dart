// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:math';

void main(List<String> args) async {
  const batchNumber = 10;
  const batchSize = 4;

  final rng = Random();

  for (var i = 0; i < batchNumber; i++) {
    final proccessesFuture = List.generate(batchSize, (i) async {
      await Future<void>.delayed(
        Duration(seconds: (2 * rng.nextDouble()).round()),
      );
      return Process.start('open', [
        'https://a16e0900d-fe2c-3609-b43c-87093e447b78.web.app/#/match_making',
      ]);
    });

    final processes = await Future.wait(proccessesFuture);
    print('Running ${processes.length} processes');

    for (final p in processes) {
      p.stderr.listen((event) {
        print(utf8.decode(event));
      });
    }

    await Future.wait(
      processes.map((p) => p.exitCode),
    );

    await Future<void>.delayed(
      Duration(seconds: (4 * rng.nextDouble()).round()),
    );

    print('Done!');
  }
}
