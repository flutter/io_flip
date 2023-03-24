import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/settings/settings.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  factory SettingsScreen.routeBuilder(_, __) {
    return const SettingsScreen(
      key: Key('settings'),
    );
  }

  static const _gap = SizedBox(height: 60);
  static const _divider = Divider(
    height: 50,
    indent: 16,
    endIndent: 16,
  );

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: TopDashColors.white,
      appBar: AppBar(
        backgroundColor: TopDashColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TopDashSpacing.sm),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: ListView(
              children: [
                _gap,
                Text(
                  l10n.settingsPageTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displayMedium,
                ),
                _gap,
                ListTile(
                  title: Text(l10n.settingsHowToPlayItem),
                  onTap: () =>
                      GoRouter.of(context).push('/settings/how_to_play'),
                  trailing: const Icon(Icons.chevron_right),
                ),
                _divider,
                ValueListenableBuilder<bool>(
                  valueListenable: settings.soundsOn,
                  builder: (context, soundsOn, child) => SwitchListTile(
                    title: Text(l10n.settingsSoundEffectsItem),
                    value: soundsOn,
                    onChanged: (_) => settings.toggleSoundsOn(),
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: settings.musicOn,
                  builder: (context, musicOn, child) => SwitchListTile(
                    title: Text(l10n.settingsMusicItem),
                    value: musicOn,
                    onChanged: (_) => settings.toggleMusicOn(),
                  ),
                ),
                _divider,
                ListTile(
                  title: Text(l10n.settingsCreditsItem),
                ),
                _gap,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
