import 'package:flutter/material.dart';
import 'package:io_flip/l10n/l10n.dart';
import 'package:io_flip/leaderboard/initials_form/initials_form.dart';
import 'package:io_flip/share/share.dart';
import 'package:io_flip_ui/top_dash_ui.dart';

class LeaderboardEntryView extends StatelessWidget {
  const LeaderboardEntryView({
    required this.scoreCardId,
    this.shareHandPageData,
    super.key,
  });

  final String scoreCardId;
  final ShareHandPageData? shareHandPageData;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return IoFlipScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TopDashSpacing.xxlg),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: TopDashSpacing.xlg),
              IoFlipLogo(width: 96.96, height: 64),
              const Spacer(),
              Text(
                l10n.enterYourInitials,
                textAlign: TextAlign.center,
                style: TopDashTextStyles.mobileH4Light,
              ),
              const SizedBox(height: TopDashSpacing.xlg),
              InitialsForm(
                scoreCardId: scoreCardId,
                shareHandPageData: shareHandPageData,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
