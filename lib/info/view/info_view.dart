import 'package:flutter/material.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/utils/utils.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

// TODO(willhlas): add links.

class InfoView extends StatelessWidget {
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final links = {
      l10n.ioLinkLabel: () {},
      l10n.privacyPolicyLinkLabel: () {},
      l10n.termsOfServiceLinkLabel: () {},
      l10n.faqLinkLabel: () {},
    };

    final descriptionStyle = TopDashTextStyles.bodyLG.copyWith(
      color: TopDashColors.seedWhite,
    );
    final linkStyle = TopDashTextStyles.bodyLG.copyWith(
      color: TopDashColors.seedYellow,
    );

    return Container(
      constraints: const BoxConstraints.expand(width: 327, height: 569),
      padding: const EdgeInsets.symmetric(
        vertical: TopDashSpacing.lg,
        horizontal: TopDashSpacing.xlg,
      ),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              const SizedBox(height: TopDashSpacing.lg * 3),
              IoFlipLogo(height: 93),
              const SizedBox(height: TopDashSpacing.xxlg + TopDashSpacing.sm),
              Text(
                l10n.infoDialogTitle,
                style: TopDashTextStyles.mobileH6Light,
              ),
              const SizedBox(height: TopDashSpacing.md),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: l10n.infoDialogDescriptionPrefix,
                  style: descriptionStyle,
                  children: [
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: l10n.infoDialogDescriptionInfixOne,
                      style: linkStyle,
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: l10n.infoDialogDescriptionInfixTwo,
                      style: descriptionStyle,
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: l10n.infoDialogDescriptionSuffix,
                      style: linkStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TopDashSpacing.xxlg + TopDashSpacing.sm),
              Text(
                l10n.infoDialogOtherLinks,
                style: TopDashTextStyles.mobileH6Light,
              ),
              for (final link in links.entries) ...[
                const SizedBox(height: TopDashSpacing.md),
                Text(
                  link.key,
                  style: linkStyle,
                )
              ]
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: CloseButton(
              color: TopDashColors.seedWhite,
              onPressed: context.maybePop,
            ),
          ),
        ],
      ),
    );
  }
}
