import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:top_dash/audio/audio_controller.dart';
import 'package:top_dash/audio/sounds.dart';
import 'package:top_dash/settings/settings.dart';

class _MockSettingsController extends Mock implements SettingsController {}

class _MockBoolValueListener extends Mock implements ValueNotifier<bool> {}

class _MockAudioPlayer extends Mock implements AudioPlayer {}

class _MockAudioPlayerFactory {
  final Map<String, AudioPlayer> players = {};
  final Map<String, StreamController<void>> controllers = {};

  AudioPlayer createPlayer({required String playerId}) {
    final player = _MockAudioPlayer();
    final streamController = StreamController<void>();

    when(
      () => player.play(
        any(),
        volume: any(named: 'volume'),
      ),
    ).thenAnswer((_) async {});
    when(() => player.onPlayerComplete).thenAnswer(
      (_) => streamController.stream,
    );
    when(player.stop).thenAnswer((_) async {});
    when(player.pause).thenAnswer((_) async {});
    when(player.resume).thenAnswer((_) async {});

    controllers[playerId] = streamController;
    return players[playerId] = player;
  }
}

ValueNotifier<bool> _createMockNotifier() {
  final notifier = _MockBoolValueListener();

  when(() => notifier.addListener(any())).thenAnswer((_) {});
  when(() => notifier.removeListener(any())).thenAnswer((_) {});
  when(() => notifier.value).thenReturn(true);

  return notifier;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AudioController', () {
    late SettingsController settingsController;
    late ValueNotifier<bool> muted;
    late ValueNotifier<bool> musicOn;
    late ValueNotifier<bool> soundsOn;

    setUpAll(() {
      registerFallbackValue(AssetSource(''));
    });

    setUp(() {
      settingsController = _MockSettingsController();

      muted = _createMockNotifier();
      when(() => settingsController.muted).thenReturn(muted);

      soundsOn = _createMockNotifier();
      when(() => settingsController.soundsOn).thenReturn(soundsOn);

      musicOn = _createMockNotifier();
      when(() => settingsController.musicOn).thenReturn(musicOn);
    });

    test('can be instantiated', () {
      expect(
        AudioController(),
        isNotNull,
      );
    });

    group('attachSettings', () {
      test('attach to the settings', () {
        AudioController().attachSettings(settingsController);

        verify(() => muted.addListener(any())).called(1);
        verify(() => musicOn.addListener(any())).called(1);
        verify(() => soundsOn.addListener(any())).called(1);
      });

      test('auto play the music if is not muted', () {
        final playerFactory = _MockAudioPlayerFactory();

        when(() => musicOn.value).thenReturn(true);
        when(() => muted.value).thenReturn(false);

        AudioController(
          createPlayer: playerFactory.createPlayer,
        ).attachSettings(
          settingsController,
        );

        final player = playerFactory.players['musicPlayer'];
        verify(() => player!.play(any())).called(1);
      });

      test('replace an old settings', () {
        final audioController = AudioController()
          ..attachSettings(settingsController);

        verify(() => muted.addListener(any())).called(1);
        verify(() => musicOn.addListener(any())).called(1);
        verify(() => soundsOn.addListener(any())).called(1);

        final newController = _MockSettingsController();

        final newMuted = _createMockNotifier();
        when(() => newController.muted).thenReturn(newMuted);

        final newSoundsOn = _createMockNotifier();
        when(() => newController.soundsOn).thenReturn(newSoundsOn);

        final newMusicOn = _createMockNotifier();
        when(() => newController.musicOn).thenReturn(newMusicOn);

        audioController.attachSettings(newController);

        verify(() => muted.removeListener(any())).called(1);
        verify(() => musicOn.removeListener(any())).called(1);
        verify(() => soundsOn.removeListener(any())).called(1);

        verify(() => newMuted.addListener(any())).called(1);
        verify(() => newMusicOn.addListener(any())).called(1);
        verify(() => newSoundsOn.addListener(any())).called(1);
      });
    });

    group('playSfx', () {
      test('plays a sfx', () {
        final playerFactory = _MockAudioPlayerFactory();

        when(() => soundsOn.value).thenReturn(true);
        when(() => musicOn.value).thenReturn(true);
        when(() => muted.value).thenReturn(false);

        AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..playSfx(SfxType.swishSwish);

        final player = playerFactory.players['sfxPlayer#0']!;

        verify(
          () => player.play(
            any(),
            volume: soundTypeToVolume(SfxType.swishSwish),
          ),
        ).called(1);
      });

      test("doesn't play when is muted", () {
        final playerFactory = _MockAudioPlayerFactory();

        when(() => soundsOn.value).thenReturn(true);
        when(() => musicOn.value).thenReturn(true);
        when(() => muted.value).thenReturn(true);

        AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..playSfx(SfxType.swishSwish);

        final player = playerFactory.players['sfxPlayer#0']!;

        verifyNever(
          () => player.play(
            any(),
            volume: soundTypeToVolume(SfxType.swishSwish),
          ),
        );
      });

      test("doesn't play when sounds is off", () {
        final playerFactory = _MockAudioPlayerFactory();

        when(() => soundsOn.value).thenReturn(false);
        when(() => musicOn.value).thenReturn(true);
        when(() => muted.value).thenReturn(false);

        AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..playSfx(SfxType.swishSwish);

        final player = playerFactory.players['sfxPlayer#0']!;

        verifyNever(
          () => player.play(
            any(),
            volume: soundTypeToVolume(SfxType.swishSwish),
          ),
        );
      });
    });

    group('muted', () {
      test('stops the music when muted', () async {
        final playerFactory = _MockAudioPlayerFactory();

        final muted = ValueNotifier(false);
        when(() => settingsController.muted).thenReturn(muted);

        when(() => soundsOn.value).thenReturn(true);
        when(() => musicOn.value).thenReturn(true);

        AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..playSfx(SfxType.swishSwish);

        final musicPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('music'))
            .value;

        final sfxPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('sfxPlayer'))
            .value;

        when(() => musicPlayer.state).thenReturn(PlayerState.playing);
        when(() => sfxPlayer.state).thenReturn(PlayerState.playing);

        muted.value = true;

        await Future.microtask(() {});

        verify(musicPlayer.pause).called(1);
        verify(sfxPlayer.stop).called(1);
      });

      test('resumes the music when unmuting', () async {
        final playerFactory = _MockAudioPlayerFactory();

        final muted = ValueNotifier(true);
        when(() => settingsController.muted).thenReturn(muted);

        when(() => soundsOn.value).thenReturn(true);
        when(() => musicOn.value).thenReturn(true);

        AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..playSfx(SfxType.swishSwish);

        final musicPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('music'))
            .value;

        when(() => musicPlayer.state).thenReturn(PlayerState.paused);

        muted.value = false;

        await Future.microtask(() {});

        verify(musicPlayer.resume).called(1);
      });
    });

    group('musicOn', () {
      test('stops the music when music is disabled', () async {
        final playerFactory = _MockAudioPlayerFactory();

        final musicOn = ValueNotifier(true);
        when(() => settingsController.musicOn).thenReturn(musicOn);

        when(() => muted.value).thenReturn(false);
        when(() => soundsOn.value).thenReturn(true);

        AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        ).attachSettings(
          settingsController,
        );

        final musicPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('music'))
            .value;

        when(() => musicPlayer.state).thenReturn(PlayerState.playing);

        musicOn.value = false;

        await Future.microtask(() {});

        verify(musicPlayer.pause).called(1);
      });
    });

    group('soundsOn', () {
      test('stops the sfx when sound is disabled', () async {
        final playerFactory = _MockAudioPlayerFactory();

        final soundsOn = ValueNotifier(true);
        when(() => settingsController.soundsOn).thenReturn(soundsOn);

        when(() => muted.value).thenReturn(false);
        when(() => musicOn.value).thenReturn(false);

        AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..playSfx(SfxType.wssh);

        final sfxPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('sfxPlayer'))
            .value;

        when(() => sfxPlayer.state).thenReturn(PlayerState.playing);

        soundsOn.value = false;

        await Future.microtask(() {});

        verify(sfxPlayer.stop).called(1);
      });
    });

    group('lifecycle handling', () {
      test('when app is paused, pauses and stop sounds', () async {
        final lifecycleNotifier = ValueNotifier(AppLifecycleState.resumed);
        final playerFactory = _MockAudioPlayerFactory();

        when(() => soundsOn.value).thenReturn(true);
        when(() => musicOn.value).thenReturn(true);
        when(() => muted.value).thenReturn(false);

        AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..attachLifecycleNotifier(lifecycleNotifier)
          ..playSfx(SfxType.swishSwish);

        final musicPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('music'))
            .value;

        final sfxPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('sfxPlayer'))
            .value;

        when(() => musicPlayer.state).thenReturn(PlayerState.playing);
        when(() => sfxPlayer.state).thenReturn(PlayerState.playing);

        lifecycleNotifier.value = AppLifecycleState.paused;

        await Future.microtask(() {});

        verify(musicPlayer.pause).called(1);
        verify(sfxPlayer.stop).called(1);
      });

      test('when app is detached, pauses and stop sounds', () async {
        final lifecycleNotifier = ValueNotifier(AppLifecycleState.resumed);
        final playerFactory = _MockAudioPlayerFactory();

        when(() => soundsOn.value).thenReturn(true);
        when(() => musicOn.value).thenReturn(true);
        when(() => muted.value).thenReturn(false);

        AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..attachLifecycleNotifier(lifecycleNotifier)
          ..playSfx(SfxType.swishSwish);

        final musicPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('music'))
            .value;

        final sfxPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('sfxPlayer'))
            .value;

        when(() => musicPlayer.state).thenReturn(PlayerState.playing);
        when(() => sfxPlayer.state).thenReturn(PlayerState.playing);

        lifecycleNotifier.value = AppLifecycleState.detached;

        await Future.microtask(() {});

        verify(musicPlayer.pause).called(1);
        verify(sfxPlayer.stop).called(1);
      });

      test('when app is inactive, do nothing', () async {
        final lifecycleNotifier = ValueNotifier(AppLifecycleState.resumed);
        final playerFactory = _MockAudioPlayerFactory();

        when(() => soundsOn.value).thenReturn(true);
        when(() => musicOn.value).thenReturn(true);
        when(() => muted.value).thenReturn(false);

        AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..attachLifecycleNotifier(lifecycleNotifier)
          ..playSfx(SfxType.swishSwish);

        final musicPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('music'))
            .value;

        final sfxPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('sfxPlayer'))
            .value;

        when(() => musicPlayer.state).thenReturn(PlayerState.playing);
        when(() => sfxPlayer.state).thenReturn(PlayerState.playing);

        lifecycleNotifier.value = AppLifecycleState.inactive;

        await Future.microtask(() {});

        verifyNever(musicPlayer.pause);
        verifyNever(sfxPlayer.stop);
      });

      test('when app is resumed, resumes the music', () async {
        final lifecycleNotifier = ValueNotifier(AppLifecycleState.inactive);
        final playerFactory = _MockAudioPlayerFactory();

        when(() => soundsOn.value).thenReturn(true);
        when(() => musicOn.value).thenReturn(true);
        when(() => muted.value).thenReturn(false);

        AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..attachLifecycleNotifier(lifecycleNotifier)
          ..playSfx(SfxType.swishSwish);

        final musicPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('music'))
            .value;

        when(() => musicPlayer.state).thenReturn(PlayerState.paused);

        lifecycleNotifier.value = AppLifecycleState.resumed;

        await Future.microtask(() {});

        verify(musicPlayer.resume).called(1);
      });

      test('when resuming, and an error happens, play the next', () async {
        final lifecycleNotifier = ValueNotifier(AppLifecycleState.paused);
        final playerFactory = _MockAudioPlayerFactory();

        when(() => soundsOn.value).thenReturn(true);
        when(() => musicOn.value).thenReturn(true);
        when(() => muted.value).thenReturn(false);

        AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..attachLifecycleNotifier(lifecycleNotifier);

        final musicPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('music'))
            .value;

        when(() => musicPlayer.state).thenReturn(PlayerState.paused);
        when(musicPlayer.resume).thenThrow('Error');

        lifecycleNotifier.value = AppLifecycleState.resumed;

        await Future.microtask(() {});

        verify(() => musicPlayer.play(any(), volume: any(named: 'volume')))
            .called(2);
      });

      test('when resuming, and player is completed, play the next', () async {
        final lifecycleNotifier = ValueNotifier(AppLifecycleState.paused);
        final playerFactory = _MockAudioPlayerFactory();

        when(() => soundsOn.value).thenReturn(true);
        when(() => musicOn.value).thenReturn(true);
        when(() => muted.value).thenReturn(false);

        AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..attachLifecycleNotifier(lifecycleNotifier);

        final musicPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('music'))
            .value;

        when(() => musicPlayer.state).thenReturn(PlayerState.completed);

        lifecycleNotifier.value = AppLifecycleState.resumed;

        await Future.microtask(() {});

        verify(() => musicPlayer.play(any(), volume: any(named: 'volume')))
            .called(2);
      });

      test('when resuming, and player is playing, do nothing', () async {
        final lifecycleNotifier = ValueNotifier(AppLifecycleState.paused);
        final playerFactory = _MockAudioPlayerFactory();

        when(() => soundsOn.value).thenReturn(true);
        when(() => musicOn.value).thenReturn(true);
        when(() => muted.value).thenReturn(false);

        AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        )
          ..attachSettings(
            settingsController,
          )
          ..attachLifecycleNotifier(lifecycleNotifier);

        final musicPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('music'))
            .value;

        when(() => musicPlayer.state).thenReturn(PlayerState.playing);

        lifecycleNotifier.value = AppLifecycleState.resumed;

        await Future.microtask(() {});

        verify(() => musicPlayer.play(any(), volume: any(named: 'volume')))
            .called(1);
      });
    });

    group('changeSong', () {
      test('plays the next song when the one is playing finishes', () async {
        final playerFactory = _MockAudioPlayerFactory();

        when(() => muted.value).thenReturn(false);
        when(() => musicOn.value).thenReturn(true);
        when(() => soundsOn.value).thenReturn(true);

        AudioController(
          createPlayer: playerFactory.createPlayer,
          polyphony: 1,
        ).attachSettings(
          settingsController,
        );

        final musicPlayer = playerFactory.players.entries
            .firstWhere((entry) => entry.key.startsWith('music'))
            .value;

        playerFactory.controllers.entries
            .firstWhere((entry) => entry.key.startsWith('music'))
            .value
            .add(null);

        await Future.microtask(() {});

        verify(() => musicPlayer.play(any(), volume: any(named: 'volume')))
            .called(2);
      });
    });
  });
}
