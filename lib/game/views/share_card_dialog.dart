import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/gen/assets.gen.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash_ui/top_dash_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ShareCardDialog extends StatelessWidget {
  const ShareCardDialog({
    required this.twitterShareUrl,
    required this.facebookShareUrl,
    required this.card,
    this.urlLauncher = launchUrlString,
    super.key,
  });

  final String twitterShareUrl;
  final String facebookShareUrl;
  final AsyncValueSetter<String> urlLauncher;
  final Card card;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TopDashColors.seedWhite,
      child: Padding(
        padding: const EdgeInsets.all(TopDashSpacing.lg),
        child: ResponsiveLayoutBuilder(
          small: (context, child) {
            return Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: _DialogContent(
                key: const Key('small_dialog'),
                isMobile: true,
                card: card,
                urlLauncher: urlLauncher,
                twitterShareUrl: twitterShareUrl,
                facebookShareUrl: facebookShareUrl,
              ),
            );
          },
          large: (context, child) {
            return Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: _DialogContent(
                key: const Key('large_dialog'),
                isMobile: false,
                card: card,
                urlLauncher: urlLauncher,
                twitterShareUrl: twitterShareUrl,
                facebookShareUrl: facebookShareUrl,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DialogContent extends StatelessWidget {
  const _DialogContent({
    required this.isMobile,
    required this.card,
    required this.urlLauncher,
    required String twitterShareUrl,
    required String facebookShareUrl,
    super.key,
  })  : _twitterShareUrl = twitterShareUrl,
        _facebookShareUrl = facebookShareUrl;

  final bool isMobile;
  final Card card;
  final AsyncValueSetter<String> urlLauncher;
  final String _twitterShareUrl;
  final String _facebookShareUrl;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      shrinkWrap: !isMobile,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: GoRouter.of(context).pop,
              ),
            ),
            const SizedBox(height: TopDashSpacing.xlg),
            GameCard(
              height: 233,
              width: 175,
              image: card.image,
              name: card.name,
              suitName: card.suit.name,
              power: card.power,
            ),
            const SizedBox(height: TopDashSpacing.xlg),
            Text(
              card.name,
              style: TopDashTextStyles.mobileH4,
            ),
            Text(card.description, style: TopDashTextStyles.bodyLG),
            const SizedBox(height: TopDashSpacing.xlg),
            RoundedButton.image(
              Image.asset(
                Assets.images.twitter.path,
                width: TopDashSpacing.xlg,
              ),
              label: l10n.twitterButtonLabel,
              onPressed: () => urlLauncher(_twitterShareUrl),
              backgroundColor: TopDashColors.seedWhite,
            ),
            const SizedBox(height: TopDashSpacing.sm),
            RoundedButton.image(
              Image.asset(
                Assets.images.facebook.path,
                width: TopDashSpacing.xlg,
              ),
              label: l10n.facebookButtonLabel,
              onPressed: () => urlLauncher(_facebookShareUrl),
              backgroundColor: TopDashColors.seedWhite,
            ),
          ],
        )
      ],
    );
  }
}
