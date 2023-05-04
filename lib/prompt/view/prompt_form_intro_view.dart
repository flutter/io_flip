import 'package:flame/cache.dart';
import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_flip/gen/assets.gen.dart';
import 'package:io_flip/l10n/l10n.dart';
import 'package:io_flip/utils/platform_aware_asset.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:provider/provider.dart';

class PromptFormIntroView extends StatelessWidget {
  const PromptFormIntroView({super.key});

  static const _gap = SizedBox(height: IoFlipSpacing.xlg);
  static const _cardMasterHeight = 312.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final images = context.read<Images>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: IoFlipSpacing.xlg),
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
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        SizedBox.square(
                          dimension: _cardMasterHeight,
                          child: SpriteAnimationWidget.asset(
                            path: platformAwareAsset(
                              desktop: Assets.images.cardMaster.keyName,
                              mobile: Assets.images.mobile.cardMaster.keyName,
                            ),
                            images: images,
                            data: SpriteAnimationData.sequenced(
                              amount: 57,
                              amountPerRow: 19,
                              textureSize: platformAwareAsset(
                                desktop: Vector2(812, 812),
                                mobile: Vector2(406, 406),
                              ),
                              stepTime: 0.04,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: _cardMasterHeight - (_gap.height! * 2),
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
                            _gap,
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
            middle: RoundedButton.text(
              l10n.letsGetStarted,
              onPressed: () => context.updateFlow<Prompt>(
                (data) => data.setIntroSeen(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
