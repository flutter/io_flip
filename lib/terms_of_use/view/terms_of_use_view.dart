import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_flip/l10n/l10n.dart';
import 'package:io_flip/terms_of_use/terms_of_use.dart';
import 'package:io_flip/utils/utils.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

class TermsOfUseView extends StatelessWidget {
  const TermsOfUseView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final linkStyle = TopDashTextStyles.linkLG.copyWith(
      color: TopDashColors.seedYellow,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.termsOfUseTitle,
          style: TopDashTextStyles.mobileH4Light,
        ),
        const SizedBox(height: TopDashSpacing.sm),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: l10n.termsOfUseDescriptionPrefix,
            style: TopDashTextStyles.bodyLG.copyWith(
              color: TopDashColors.seedWhite,
            ),
            children: [
              const TextSpan(text: ' '),
              TextSpan(
                text: l10n.termsOfUseDescriptionInfixOne,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => openLink(ExternalLinks.termsOfService),
                style: linkStyle,
              ),
              const TextSpan(text: ' '),
              TextSpan(text: l10n.termsOfUseDescriptionInfixTwo),
              const TextSpan(text: ' '),
              TextSpan(
                text: l10n.termsOfUseDescriptionSuffix,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => openLink(ExternalLinks.privacyPolicy),
                style: linkStyle,
              ),
            ],
          ),
        ),
        const SizedBox(height: TopDashSpacing.xxlg),
        RoundedButton.text(
          l10n.termsOfUseContinueLabel,
          onPressed: () {
            context.read<TermsOfUseCubit>().acceptTermsOfUse();
            context.maybePop();
          },
        ),
      ],
    );
  }
}
