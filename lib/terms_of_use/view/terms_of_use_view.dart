import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/terms_of_use/terms_of_use.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

// TODO(willhlas): add policy links.

class TermsOfUseView extends StatelessWidget {
  const TermsOfUseView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final linkStyle = TopDashTextStyles.linkLG.copyWith(
      color: TopDashColors.seedWhite,
    );

    return Container(
      constraints: const BoxConstraints.expand(width: 351, height: 568),
      padding: const EdgeInsets.symmetric(
        vertical: TopDashSpacing.lg * 2,
        horizontal: TopDashSpacing.xlg,
      ),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                  style: linkStyle,
                ),
                const TextSpan(text: ' '),
                TextSpan(text: l10n.termsOfUseDescriptionInfixTwo),
                const TextSpan(text: ' '),
                TextSpan(
                  text: l10n.termsOfUseDescriptionSuffix,
                  style: linkStyle,
                ),
              ],
            ),
          ),
          const SizedBox(height: TopDashSpacing.xxlg),
          RoundedButton.text(
            l10n.termsOfUseAcceptLabel,
            onPressed: () {
              context.read<TermsOfUseCubit>().acceptTermsOfUse();
              maybePop(context);
            },
          ),
          const SizedBox(height: TopDashSpacing.sm),
          RoundedButton.text(
            l10n.termsOfUseDeclineLabel,
            backgroundColor: TopDashColors.seedBlack,
            foregroundColor: TopDashColors.seedWhite,
            borderColor: TopDashColors.seedPaletteNeutral40,
            onPressed: () => maybePop(context),
          ),
        ],
      ),
    );
  }

  void maybePop(BuildContext context) {
    final router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
    }
  }
}
