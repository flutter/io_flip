import 'package:flutter/material.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/leaderboard/initials_form/initials_form.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class LeaderboardEntryView extends StatelessWidget {
  const LeaderboardEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    const white = TopDashColors.white;

    return Scaffold(
      backgroundColor: TopDashColors.backgroundLeaderboardEntry,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TopDashSpacing.xxlg),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.youMadeItToTheLeaderboard,
                style: textTheme.titleMedium?.copyWith(
                  color: white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                l10n.enterYourInitials,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: white,
                ),
              ),
              const SizedBox(height: TopDashSpacing.xxlg),
              const InitialsForm()
            ],
          ),
        ),
      ),
    );
  }
}
