import 'package:flutter/material.dart';
import 'package:io_flip/l10n/l10n.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

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
          style: TopDashTextStyles.headlineH4,
        ),
        const SizedBox(height: TopDashSpacing.sm),
        Text(
          l10n.quitGameDialogDescription,
          textAlign: TextAlign.center,
          style: TopDashTextStyles.bodyLG,
        ),
        const SizedBox(height: TopDashSpacing.xlg),
        RoundedButton.text(
          l10n.continueLabel,
          onPressed: onConfirm,
        ),
        const SizedBox(height: TopDashSpacing.sm),
        RoundedButton.text(
          l10n.cancel,
          backgroundColor: TopDashColors.seedWhite,
          onPressed: onCancel,
        ),
      ],
    );
  }
}
