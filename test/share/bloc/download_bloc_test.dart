import 'dart:typed_data';

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/share/bloc/download_bloc.dart';

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

  group('DownloadBloc', () {
    late ShareResource shareResource;

    setUp(() {
      shareResource = _MockShareResource();
      when(() => shareResource.getShareImage(any()))
          .thenAnswer((_) async => Uint8List(8));
      when(() => file.saveTo(any())).thenAnswer((_) async {});
    });

    group('Download Requested', () {
      blocTest<DownloadBloc, DownloadState>(
        'can request a Download',
        build: () => DownloadBloc(
          shareResource: shareResource,
          parseBytes: (bytes, {String? mimeType, String? name}) {
            return file;
          },
        ),
        act: (bloc) => bloc.add(
          const DownloadRequested(card: card),
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
        'emits failure when an error occured',
        setUp: () {
          when(() => shareResource.getShareImage(any()))
              .thenThrow(Exception('oops'));
        },
        build: () => DownloadBloc(
          shareResource: shareResource,
        ),
        act: (bloc) => bloc.add(const DownloadRequested(card: card)),
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
