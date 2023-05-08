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
  const deck = Deck(id: '', userId: '', cards: [card]);

  group('DownloadCardsRequested', () {
    test('can be instantiated', () {
      expect(
        DownloadCardsRequested(cards: const [card]),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        DownloadCardsRequested(cards: const [card]),
        equals(DownloadCardsRequested(cards: const [card])),
      );
    });
  });

  group('DownloadDeckRequested', () {
    test('can be instantiated', () {
      expect(
        DownloadDeckRequested(deck: deck),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        DownloadDeckRequested(deck: deck),
        equals(DownloadDeckRequested(deck: deck)),
      );
    });
  });
}
