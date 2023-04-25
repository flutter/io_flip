import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/gen/assets.gen.dart';
import 'package:top_dash/how_to_play/view/how_to_play_dialog.dart';
import 'package:top_dash/info/info.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/leaderboard/leaderboard.dart';
import 'package:top_dash/terms_of_use/terms_of_use.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

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
        body: Stack(
          children: [
            const Align(
              alignment: Alignment.topCenter,
              child: _MainMenuScreenView(key: Key('main menu view')),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: IoFlipBottomBar(
                leading: RoundedButton.svg(
                  key: const Key('info_button'),
                  Assets.icons.info,
                  onPressed: () => TopDashDialog.show(
                    context,
                    const InfoView(),
                  ),
                ),
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
                          TopDashDialog.show(
                            context,
                            const TermsOfUseView(),
                          );
                        }
                      },
                    );
                  },
                ),
                trailing: RoundedButton.icon(
                  Icons.question_mark_rounded,
                  onPressed: () => TopDashDialog.show(
                    context,
                    const HowToPlayDialog(),
                  ),
                ),
              ),
            ),
          ],
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
            Assets.images.main.path,
            height: 312,
            fit: BoxFit.fitHeight,
          ),
          const LeaderboardView(),
          const SizedBox(height: TopDashSpacing.xxlg),
        ],
      ),
    );
  }
}
