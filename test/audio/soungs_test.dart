// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/audio/songs.dart';

void main() {
  group('Song', () {
    test('toString returns correctly', () {
      expect(
        Song('SONG.mp3', 'SONG').toString(),
        equals('Song<SONG.mp3>'),
      );
    });
  });
}
