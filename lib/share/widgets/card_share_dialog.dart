import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:go_router/go_router.dart';
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
    return Dialog(
      insetPadding: const EdgeInsets.all(TopDashSpacing.md),
      backgroundColor: TopDashColors.seedBlack,
      child: Padding(
        padding: const EdgeInsets.all(TopDashSpacing.lg),
        child: ResponsiveLayoutBuilder(
          small: (context, child) {
            return Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: _DialogContent(
                key: const Key('small_dialog'),
                isMobile: true,
                content: content,
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
                content: content,
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
    required this.content,
    required this.urlLauncher,
    required String twitterShareUrl,
    required String facebookShareUrl,
    super.key,
  })  : _twitterShareUrl = twitterShareUrl,
        _facebookShareUrl = facebookShareUrl;

  final bool isMobile;
  final Widget content;
  final AsyncValueSetter<String> urlLauncher;
  final String _twitterShareUrl;
  final String _facebookShareUrl;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      shrinkWrap: !isMobile,
      children: [
        const _CloseButton(),
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
              onPressed: () => urlLauncher(_twitterShareUrl),
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
              onPressed: () => urlLauncher(_facebookShareUrl),
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

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: const Icon(
          Icons.close,
          color: TopDashColors.seedWhite,
        ),
        onPressed: GoRouter.of(context).pop,
      ),
    );
  }
}
