import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:io_flip/gen/assets.gen.dart';
import 'package:io_flip/how_to_play/how_to_play.dart';
import 'package:io_flip/info/info.dart';
import 'package:io_flip/l10n/l10n.dart';
import 'package:io_flip/leaderboard/leaderboard.dart';
import 'package:io_flip/terms_of_use/terms_of_use.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  factory MainMenuScreen.routeBuilder(_, __) {
    return const MainMenuScreen(
      key: Key('main menu'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider<LeaderboardBloc>(
      create: (context) {
        final leaderboardResource = context.read<LeaderboardResource>();
        return LeaderboardBloc(
          leaderboardResource: leaderboardResource,
        )..add(const LeaderboardRequested());
      },
      child: IoFlipScaffold(
        body: const Align(
          child: _MainMenuScreenView(key: Key('main menu view')),
        ),
        bottomBar: IoFlipBottomBar(
          leading: const InfoButton(),
          middle: BlocConsumer<TermsOfUseCubit, bool>(
            listener: (context, termsAccepted) {
              if (termsAccepted) {
                GoRouter.of(context).go('/prompt');
              }
            },
            builder: (context, termsAccepted) {
              return RoundedButton.text(
                l10n.play,
                onPressed: () {
                  if (termsAccepted) {
                    GoRouter.of(context).go('/prompt');
                  } else {
                    IoFlipDialog.show(
                      context,
                      child: const TermsOfUseView(),
                      showCloseButton: false,
                    );
                  }
                },
              );
            },
          ),
          trailing: RoundedButton.icon(
            Icons.question_mark_rounded,
            onPressed: () => IoFlipDialog.show(
              context,
              child: const HowToPlayDialog(),
            ),
          ),
        ),
      ),
    );
  }
}

class _MainMenuScreenView extends StatelessWidget {
  const _MainMenuScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset(
            platformAwareAsset(
              desktop: Assets.images.desktop.main.path,
              mobile: Assets.images.mobile.main.path,
            ),
            height: 312,
            fit: BoxFit.fitHeight,
          ),
          const LeaderboardView(),
          const SizedBox(height: IoFlipSpacing.xxlg),
        ],
      ),
    );
  }
}
