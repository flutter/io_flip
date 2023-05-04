import 'package:api_client/api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_flip/gen/assets.gen.dart';
import 'package:io_flip/l10n/l10n.dart';
import 'package:io_flip/share/bloc/download_bloc.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ShareDialog extends StatelessWidget {
  const ShareDialog({
    required this.twitterShareUrl,
    required this.facebookShareUrl,
    required this.content,
    required this.downloadContent,
    this.urlLauncher,
    super.key,
  });

  final String twitterShareUrl;
  final String facebookShareUrl;
  final AsyncValueSetter<String>? urlLauncher;
  final Widget content;
  final Card downloadContent;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DownloadBloc(shareResource: context.read<ShareResource>()),
      child: ShareDialogView(
        twitterShareUrl: twitterShareUrl,
        facebookShareUrl: facebookShareUrl,
        content: content,
        urlLauncher: urlLauncher,
        downloadContent: downloadContent,
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
    required this.downloadContent,
    AsyncValueSetter<String>? urlLauncher,
    super.key,
  }) : _urlLauncher = urlLauncher ?? launchUrlString;

  final String twitterShareUrl;
  final String facebookShareUrl;
  final AsyncValueSetter<String> _urlLauncher;
  final Widget content;
  final Card downloadContent;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.watch<DownloadBloc>();
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          content,
          const SizedBox(height: IoFlipSpacing.xlg),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RoundedButton.image(
                Image.asset(
                  Assets.images.twitter.path,
                  width: IoFlipSpacing.xlg,
                  color: IoFlipColors.seedWhite,
                ),
                label: l10n.twitterButtonLabel,
                onPressed: () => _urlLauncher(twitterShareUrl),
              ),
              const SizedBox(height: IoFlipSpacing.sm),
              RoundedButton.image(
                Image.asset(
                  Assets.images.facebook.path,
                  color: IoFlipColors.seedWhite,
                  width: IoFlipSpacing.xlg,
                ),
                label: l10n.facebookButtonLabel,
                onPressed: () => _urlLauncher(facebookShareUrl),
              ),
              const SizedBox(height: IoFlipSpacing.sm),
              _SaveButton(
                status: bloc.state.status,
                onSave: () =>
                    bloc.add(DownloadRequested(card: downloadContent)),
              ),
              const SizedBox(height: IoFlipSpacing.sm),
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
              width: IoFlipSpacing.xlg,
              height: IoFlipSpacing.xlg,
              child: CircularProgressIndicator(
                color: IoFlipColors.seedGrey70,
                strokeWidth: 2,
              ),
            ),
            label: l10n.downloadingButtonLabel,
            borderColor: IoFlipColors.seedGrey50,
            foregroundColor: IoFlipColors.seedGrey70,
            backgroundColor: IoFlipColors.seedGrey30,
          )
        : RoundedButton.image(
            Image.asset(
              Assets.images.download.path,
              color: IoFlipColors.seedWhite,
              width: IoFlipSpacing.xlg,
            ),
            label: l10n.saveButtonLabel,
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
        height: IoFlipSpacing.xxlg,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: success ? IoFlipColors.seedGreen : IoFlipColors.seedRed,
        ),
        child: Center(
          child: Text(
            success ? l10n.downloadCompleteLabel : l10n.downloadFailedLabel,
            style:
                IoFlipTextStyles.bodyMD.copyWith(color: IoFlipColors.seedBlack),
          ),
        ),
      ),
    );
  }
}
