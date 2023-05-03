// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/share/bloc/download_bloc.dart';

void main() {
  group('DownloadState', () {
    test('can be instantiated', () {
      expect(
        DownloadState(),
        isNotNull,
      );
    });

    test('has the correct initial state', () {
      expect(
        DownloadState().status,
        equals(
          DownloadStatus.idle,
        ),
      );
    });

    test('supports equality', () {
      expect(
        DownloadState(),
        equals(
          DownloadState(),
        ),
      );

      expect(
        DownloadState(
          status: DownloadStatus.completed,
        ),
        isNot(
          equals(
            DownloadState(),
          ),
        ),
      );
    });

    test('copyWith returns a new instance', () {
      final state = DownloadState();
      expect(
        state.copyWith(status: DownloadStatus.completed),
        equals(
          DownloadState(
            status: DownloadStatus.completed,
          ),
        ),
      );
    });
  });
}
