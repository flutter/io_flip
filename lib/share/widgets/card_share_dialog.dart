import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:top_dash/gen/assets.gen.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash_ui/top_dash_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CardShareDialog extends StatelessWidget {
  const CardShareDialog({
    required this.twitterShareUrl,
    required this.facebookShareUrl,
    required this.content,
    this.urlLauncher = launchUrlString,
    super.key,
  });

  final String twitterShareUrl;
  final String facebookShareUrl;
  final AsyncValueSetter<String> urlLauncher;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        content,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RoundedButton.image(
              Image.asset(
                Assets.images.twitter.path,
                width: TopDashSpacing.xlg,
                color: TopDashColors.seedWhite,
              ),
              label: l10n.twitterButtonLabel,
              onPressed: () => urlLauncher(twitterShareUrl),
              backgroundColor: TopDashColors.seedBlack,
              foregroundColor: TopDashColors.seedWhite,
              borderColor: TopDashColors.seedPaletteNeutral40,
            ),
            const SizedBox(height: TopDashSpacing.sm),
            RoundedButton.image(
              Image.asset(
                Assets.images.facebook.path,
                color: TopDashColors.seedWhite,
                width: TopDashSpacing.xlg,
              ),
              label: l10n.facebookButtonLabel,
              onPressed: () => urlLauncher(facebookShareUrl),
              backgroundColor: TopDashColors.seedBlack,
              foregroundColor: TopDashColors.seedWhite,
              borderColor: TopDashColors.seedPaletteNeutral40,
            ),
          ],
        ),
      ],
    );
  }
}
