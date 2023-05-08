import 'dart:typed_data';

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_flip/share/bloc/download_bloc.dart';
import 'package:mocktail/mocktail.dart';

class _MockShareResource extends Mock implements ShareResource {}

class _MockXFile extends Mock implements XFile {}

void main() {
  final XFile file = _MockXFile();
  const card = Card(
    id: '0',
    name: '',
    description: '',
    image: '',
    rarity: false,
    power: 20,
    suit: Suit.fire,
  );
  const deck = Deck(id: 'id', userId: 'userId', cards: [card]);

  group('DownloadBloc', () {
    late ShareResource shareResource;
    setUp(() {
      shareResource = _MockShareResource();
      when(() => shareResource.getShareCardImage(any()))
          .thenAnswer((_) async => Uint8List(8));
      when(() => shareResource.getShareDeckImage(any()))
          .thenAnswer((_) async => Uint8List(8));
      when(() => file.saveTo(any())).thenAnswer((_) async {});
    });

    group('Download Cards Requested', () {
      blocTest<DownloadBloc, DownloadState>(
        'can request a Download',
        build: () => DownloadBloc(
          shareResource: shareResource,
          parseBytes: (bytes, {String? mimeType, String? name}) {
            return file;
          },
        ),
        act: (bloc) => bloc.add(
          const DownloadCardsRequested(cards: [card]),
        ),
        expect: () => const [
          DownloadState(
            status: DownloadStatus.loading,
          ),
          DownloadState(
            status: DownloadStatus.completed,
          ),
        ],
      );

      blocTest<DownloadBloc, DownloadState>(
        'emits failure when an error occurred',
        setUp: () {
          when(() => shareResource.getShareCardImage(any()))
              .thenThrow(Exception('oops'));
        },
        build: () => DownloadBloc(
          shareResource: shareResource,
        ),
        act: (bloc) => bloc.add(const DownloadCardsRequested(cards: [card])),
        expect: () => const [
          DownloadState(
            status: DownloadStatus.loading,
          ),
          DownloadState(
            status: DownloadStatus.failure,
          ),
        ],
      );
    });

    group('Download Deck Requested', () {
      blocTest<DownloadBloc, DownloadState>(
        'can request a Download',
        build: () => DownloadBloc(
          shareResource: shareResource,
          parseBytes: (bytes, {String? mimeType, String? name}) {
            return file;
          },
        ),
        act: (bloc) => bloc.add(
          const DownloadDeckRequested(deck: deck),
        ),
        expect: () => const [
          DownloadState(
            status: DownloadStatus.loading,
          ),
          DownloadState(
            status: DownloadStatus.completed,
          ),
        ],
      );

      blocTest<DownloadBloc, DownloadState>(
        'emits failure when an error occurred',
        setUp: () {
          when(() => shareResource.getShareDeckImage(any()))
              .thenThrow(Exception('oops'));
        },
        build: () => DownloadBloc(
          shareResource: shareResource,
        ),
        act: (bloc) => bloc.add(const DownloadDeckRequested(deck: deck)),
        expect: () => const [
          DownloadState(
            status: DownloadStatus.loading,
          ),
          DownloadState(
            status: DownloadStatus.failure,
          ),
        ],
      );
    });
  });
}
