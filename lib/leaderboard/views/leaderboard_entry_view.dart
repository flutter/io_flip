import 'package:flutter/material.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/leaderboard/initials_form/initials_form.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class LeaderboardEntryView extends StatelessWidget {
  const LeaderboardEntryView({
    required this.scoreCardId,
    super.key,
  });

  final String scoreCardId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TopDashSpacing.xxlg),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.enterYourInitials,
                textAlign: TextAlign.center,
                style: TopDashTextStyles.mobileH4,
              ),
              const SizedBox(height: TopDashSpacing.xlg),
              InitialsForm(scoreCardId: scoreCardId)
            ],
          ),
        ),
      ),
    );
  }
}
