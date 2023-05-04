// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_flip/share/bloc/download_bloc.dart';

void main() {
  const card = Card(
    id: '0',
    name: '',
    description: '',
    image: '',
    rarity: false,
    power: 20,
    suit: Suit.fire,
  );
  group('DownloadRequested', () {
    test('can be instantiated', () {
      expect(
        DownloadRequested(card: card),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        DownloadRequested(card: card),
        equals(DownloadRequested(card: card)),
      );
    });
  });
}
