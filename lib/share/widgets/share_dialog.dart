import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:top_dash/gen/assets.gen.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash_ui/top_dash_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ShareDialog extends StatelessWidget {
  const ShareDialog({
    required this.twitterShareUrl,
    required this.facebookShareUrl,
    required this.content,
    AsyncValueSetter<String>? urlLauncher,
    super.key,
    this.loading = false,
    this.success = false,
  }) : _urlLauncher = urlLauncher ?? launchUrlString;

  final String twitterShareUrl;
  final String facebookShareUrl;
  final AsyncValueSetter<String> _urlLauncher;
  final Widget content;
  final bool loading;
  final bool success;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          content,
          const SizedBox(height: TopDashSpacing.xlg),
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
                onPressed: () => _urlLauncher(twitterShareUrl),
              ),
              const SizedBox(height: TopDashSpacing.sm),
              RoundedButton.image(
                Image.asset(
                  Assets.images.facebook.path,
                  color: TopDashColors.seedWhite,
                  width: TopDashSpacing.xlg,
                ),
                label: l10n.facebookButtonLabel,
                onPressed: () => _urlLauncher(facebookShareUrl),
              ),
              const SizedBox(height: TopDashSpacing.sm),
              _SaveButton(
                loading: loading,
              ),
              const SizedBox(height: TopDashSpacing.sm),
              _DownloadStatusBar(visible: loading, success: success),
            ],
          ),
        ],
      ),
    );
  }
}

// TODO(Samobrien): Implement download bloc and call it on save button tap
class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.loading});

  final bool loading;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return loading
        ? RoundedButton.image(
            const CircularProgressIndicator(
              color: TopDashColors.seedGrey70,
              strokeWidth: 2,
            ),
            label: l10n.downloadingButtonLabel,
            borderColor: TopDashColors.seedGrey50,
            foregroundColor: TopDashColors.seedGrey70,
            backgroundColor: TopDashColors.seedGrey30,
          )
        : RoundedButton.image(
            Image.asset(
              Assets.images.download.path,
              color: TopDashColors.seedWhite,
            ),
            label: l10n.saveButtonLabel,
          );
  }
}

class _DownloadStatusBar extends StatelessWidget {
  const _DownloadStatusBar({
    required this.success,
    required this.visible,
  });
  final bool visible;
  final bool success;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Visibility(
      visible: visible,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 327),
        child: Container(
          height: TopDashSpacing.xxlg,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: success ? TopDashColors.seedGreen : TopDashColors.seedRed,
          ),
          child: Center(
            child: Text(
              success ? l10n.downloadCompleteLabel : l10n.downloadFailedLabel,
              style: TopDashTextStyles.bodyMD
                  .copyWith(color: TopDashColors.seedBlack),
            ),
          ),
        ),
      ),
    );
  }
}
