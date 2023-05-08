import 'package:flutter/material.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_flip/audio/audio.dart';
import 'package:io_flip/l10n/l10n.dart';
import 'package:io_flip/prompt/prompt.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

class PromptFormIntroView extends StatelessWidget {
  const PromptFormIntroView({super.key});

  static const _gap = SizedBox(height: IoFlipSpacing.xlg);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            constraints: const BoxConstraints(maxWidth: 516),
            padding: const EdgeInsets.symmetric(horizontal: IoFlipSpacing.xlg),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      const CardMaster(),
                      Column(
                        children: [
                          SizedBox(
                            height: CardMaster.cardMasterHeight -
                                (PromptFormIntroView._gap.height! * 2),
                          ),
                          Text(
                            l10n.niceToMeetYou,
                            style: IoFlipTextStyles.headlineH4Light,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: IoFlipSpacing.sm),
                          Text(
                            l10n.introTextPromptPage,
                            style: IoFlipTextStyles.headlineH6Light,
                            textAlign: TextAlign.center,
                          ),
                          PromptFormIntroView._gap,
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        IoFlipBottomBar(
          leading: const AudioToggleButton(),
          middle: RoundedButton.text(
            l10n.letsGetStarted,
            onPressed: () => context.updateFlow<Prompt>(
              (data) => data.setIntroSeen(),
            ),
          ),
        ),
      ],
    );
  }
}
