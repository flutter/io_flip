import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:game_domain/game_domain.dart';
import 'package:top_dash/gen/assets.gen.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class PromptFormIntroView extends StatelessWidget {
  const PromptFormIntroView({super.key});

  static const _gap = SizedBox(height: TopDashSpacing.xlg);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TopDashSpacing.xlg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              constraints: const BoxConstraints(maxWidth: 516),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _gap,
                    Image.asset(
                      Assets.images.cardMaster.path,
                      height: 156,
                      width: 156,
                    ),
                    _gap,
                    Text(
                      l10n.cardMaster,
                      style: TopDashTextStyles.headlineH4Light,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: TopDashSpacing.sm),
                    Text(
                      l10n.niceToMeetYou,
                      style: TopDashTextStyles.headlineH6Light,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: TopDashSpacing.sm),
                    Text(
                      l10n.introTextPromptPage,
                      style: TopDashTextStyles.headlineH6Light,
                      textAlign: TextAlign.center,
                    ),
                    _gap,
                  ],
                ),
              ),
            ),
          ),
          RoundedButton.text(
            l10n.letsGetStarted.toUpperCase(),
            onPressed: () =>
                context.flow<Prompt>().update((data) => data.setIntroSeen()),
          ),
        ],
      ),
    );
  }
}
