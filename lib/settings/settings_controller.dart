// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:io_flip/settings/persistence/persistence.dart';

/// An class that holds settings like [soundsOn] or [musicOn],
/// and saves them to an injected persistence store.
class SettingsController {
  /// Creates a new instance of [SettingsController] backed by [persistence].
  SettingsController({required SettingsPersistence persistence})
      : _persistence = persistence;
  final SettingsPersistence _persistence;

  ValueNotifier<bool> soundsOn = ValueNotifier(false);

  ValueNotifier<bool> musicOn = ValueNotifier(false);

  /// Asynchronously loads values from the injected persistence store.
  Future<void> loadStateFromPersistence() async {
    await Future.wait([
      // On the web, sound can only start after user interaction, so
      // we start muted there.
      // On any other platform, we start unmuted.
      _persistence
          .getSoundsOn(defaultValue: !kIsWeb)
          .then((value) => soundsOn.value = value),
      _persistence
          .getMusicOn(defaultValue: !kIsWeb)
          .then((value) => musicOn.value = value),
    ]);
  }

  void toggleMusicOn() {
    musicOn.value = !musicOn.value;
    _persistence.saveMusicOn(active: musicOn.value);
  }

  void toggleSoundsOn() {
    soundsOn.value = !soundsOn.value;
    _persistence.saveSoundsOn(active: soundsOn.value);
  }
}
