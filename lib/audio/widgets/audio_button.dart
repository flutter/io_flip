import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_flip/settings/settings_controller.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

class AudioToggleButton extends StatelessWidget {
  const AudioToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    return ValueListenableBuilder<bool>(
      valueListenable: settings.muted,
      builder: (_, muted, __) {
        return RoundedButton.icon(
          muted ? Icons.volume_off : Icons.volume_up,
          onPressed: settings.toggleMuted,
        );
      },
    );
  }
}
