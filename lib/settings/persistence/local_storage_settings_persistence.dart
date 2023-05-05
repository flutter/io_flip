// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:io_flip/settings/persistence/persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// An implementation of [SettingsPersistence] that uses
/// `package:shared_preferences`.
class LocalStorageSettingsPersistence extends SettingsPersistence {
  final Future<SharedPreferences> instanceFuture =
      SharedPreferences.getInstance();

  @override
  Future<bool> getMusicOn() async {
    final prefs = await instanceFuture;
    return prefs.getBool('musicOn') ?? true;
  }

  @override
  Future<bool> getMuted({required bool defaultValue}) async {
    final prefs = await instanceFuture;
    return prefs.getBool('mute') ?? defaultValue;
  }

  @override
  Future<bool> getSoundsOn() async {
    final prefs = await instanceFuture;
    return prefs.getBool('soundsOn') ?? true;
  }

  @override
  Future<void> saveMusicOn({required bool active}) async {
    final prefs = await instanceFuture;
    await prefs.setBool('musicOn', active);
  }

  @override
  Future<void> saveMuted({required bool active}) async {
    final prefs = await instanceFuture;
    await prefs.setBool('mute', active);
  }

  @override
  Future<void> saveSoundsOn({required bool active}) async {
    final prefs = await instanceFuture;
    await prefs.setBool('soundsOn', active);
  }
}
