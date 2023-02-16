import 'package:flutter_test/flutter_test.dart';
import 'package:top_dash/audio/sounds.dart';

void main() {
  group('Sounds', () {
    test('soundTypeToFilename returns correctly', () {
      expect(
        soundTypeToFilename(SfxType.huhsh),
        equals([
          'hash1.mp3',
          'hash2.mp3',
          'hash3.mp3',
        ]),
      );
      expect(
        soundTypeToFilename(SfxType.wssh),
        equals([
          'wssh1.mp3',
          'wssh2.mp3',
          'dsht1.mp3',
          'ws1.mp3',
          'spsh1.mp3',
          'hh1.mp3',
          'hh2.mp3',
          'kss1.mp3',
        ]),
      );
      expect(
        soundTypeToFilename(SfxType.buttonTap),
        equals([
          'k1.mp3',
          'k2.mp3',
          'p1.mp3',
          'p2.mp3',
        ]),
      );
      expect(
        soundTypeToFilename(SfxType.congrats),
        equals([
          'yay1.mp3',
          'wehee1.mp3',
          'oo1.mp3',
        ]),
      );
      expect(
        soundTypeToFilename(SfxType.erase),
        equals([
          'fwfwfwfwfw1.mp3',
          'fwfwfwfw1.mp3',
        ]),
      );
      expect(
        soundTypeToFilename(SfxType.swishSwish),
        equals([
          'swishswish1.mp3',
        ]),
      );
    });

    test('soundTypeToVolume', () {
      expect(
        soundTypeToVolume(SfxType.huhsh),
        equals(.4),
      );
      expect(
        soundTypeToVolume(SfxType.wssh),
        equals(.2),
      );
      expect(
        soundTypeToVolume(SfxType.buttonTap),
        equals(1),
      );
      expect(
        soundTypeToVolume(SfxType.congrats),
        equals(1),
      );
      expect(
        soundTypeToVolume(SfxType.erase),
        equals(1),
      );
      expect(
        soundTypeToVolume(SfxType.swishSwish),
        equals(1),
      );
    });
  });
}
