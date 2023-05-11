import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_flip/settings/settings_controller.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

class AudioToggleButton extends StatelessWidget {
  const AudioToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: settings.musicOn,
          builder: (_, on, __) {
            return RoundedButton.icon(
              on ? Icons.music_note : Icons.music_off,
              onPressed: settings.toggleMusicOn,
            );
          },
        ),
        const SizedBox(width: 8),
        ValueListenableBuilder<bool>(
          valueListenable: settings.soundsOn,
          builder: (_, on, __) {
            return RoundedButton.icon(
              on ? Icons.volume_up : Icons.volume_off,
              onPressed: settings.toggleSoundsOn,
            );
          },
        ),
      ],
    );
  }
}
