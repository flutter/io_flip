import 'package:api_client/api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_dash/gen/assets.gen.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/share/bloc/download_bloc.dart';
import 'package:top_dash_ui/top_dash_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ShareDialog extends StatelessWidget {
  const ShareDialog({
    required this.twitterShareUrl,
    required this.facebookShareUrl,
    required this.content,
    required this.downloadRequest,
    this.urlLauncher,
    super.key,
  });

  final String twitterShareUrl;
  final String facebookShareUrl;
  final AsyncValueSetter<String>? urlLauncher;
  final Widget content;
  final DownloadRequested downloadRequest;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DownloadBloc(shareResource: context.read<ShareResource>()),
      child: ShareDialogView(
        twitterShareUrl: twitterShareUrl,
        facebookShareUrl: facebookShareUrl,
        content: content,
        urlLauncher: urlLauncher,
        downloadRequest: downloadRequest,
        key: key,
      ),
    );
  }
}

class ShareDialogView extends StatelessWidget {
  const ShareDialogView({
    required this.twitterShareUrl,
    required this.facebookShareUrl,
    required this.content,
    required this.downloadRequest,
    AsyncValueSetter<String>? urlLauncher,
    super.key,
  }) : _urlLauncher = urlLauncher ?? launchUrlString;

  final String twitterShareUrl;
  final String facebookShareUrl;
  final AsyncValueSetter<String> _urlLauncher;
  final Widget content;
  final DownloadRequested downloadRequest;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.watch<DownloadBloc>();
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
                status: bloc.state.status,
                onSave: () => bloc.add(downloadRequest),
              ),
              const SizedBox(height: TopDashSpacing.sm),
              if (bloc.state.status != DownloadStatus.idle &&
                  bloc.state.status != DownloadStatus.loading)
                _DownloadStatusBar(status: bloc.state.status),
            ],
          ),
        ],
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.status, required this.onSave});

  final DownloadStatus status;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return status == DownloadStatus.loading
        ? RoundedButton.image(
            const SizedBox(
              width: TopDashSpacing.xlg,
              height: TopDashSpacing.xlg,
              child: CircularProgressIndicator(
                color: TopDashColors.seedGrey70,
                strokeWidth: 2,
              ),
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
              width: TopDashSpacing.xlg,
            ),
            label: 'SAVE',
            onPressed: onSave,
          );
  }
}

class _DownloadStatusBar extends StatelessWidget {
  const _DownloadStatusBar({required this.status});

  final DownloadStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final success = status == DownloadStatus.completed;
    return ConstrainedBox(
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
    );
  }
}
