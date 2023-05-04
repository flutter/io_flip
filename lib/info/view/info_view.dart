import 'package:flutter/material.dart';
import 'package:io_flip/l10n/l10n.dart';
import 'package:io_flip/utils/utils.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

class InfoView extends StatelessWidget {
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final links = {
      l10n.ioLinkLabel: ExternalLinks.googleIO,
      l10n.privacyPolicyLinkLabel: ExternalLinks.privacyPolicy,
      l10n.termsOfServiceLinkLabel: ExternalLinks.termsOfService,
      l10n.faqLinkLabel: ExternalLinks.faq,
    };

    final descriptionStyle = TopDashTextStyles.bodyLG.copyWith(
      color: TopDashColors.seedWhite,
    );
    final linkStyle = TopDashTextStyles.bodyLG.copyWith(
      color: TopDashColors.seedYellow,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
    );
  }
}
