import 'package:flutter/material.dart';
import 'package:io_flip/l10n/l10n.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

class QuitGameDialog extends StatelessWidget {
  const QuitGameDialog({
    required this.onConfirm,
    required this.onCancel,
    super.key,
  });

  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.quitGameDialogTitle,
          style: IoFlipTextStyles.headlineH4,
        ),
        const SizedBox(height: IoFlipSpacing.sm),
        Text(
          l10n.quitGameDialogDescription,
          textAlign: TextAlign.center,
          style: IoFlipTextStyles.bodyLG,
        ),
        const SizedBox(height: IoFlipSpacing.xlg),
        RoundedButton.text(
          l10n.continueLabel,
          onPressed: onConfirm,
        ),
        const SizedBox(height: IoFlipSpacing.sm),
        RoundedButton.text(
          l10n.cancel,
          backgroundColor: IoFlipColors.seedWhite,
          onPressed: onCancel,
        ),
      ],
    );
  }
}
