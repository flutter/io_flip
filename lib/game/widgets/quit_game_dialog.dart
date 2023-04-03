import 'package:flutter/material.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class QuitGameDialog extends StatelessWidget {
  const QuitGameDialog({
    required this.onConfirm,
    required this.onCancel,
    super.key,
  });

  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  static void show(
    BuildContext context, {
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) =>
      showDialog<Widget>(
        context: context,
        builder: (context) => QuitGameDialog(
          onConfirm: onConfirm,
          onCancel: onCancel,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Dialog(
      child: Container(
        width: 327,
        padding: const EdgeInsets.symmetric(
          horizontal: TopDashSpacing.lg,
        ).copyWith(
          top: TopDashSpacing.lg,
          bottom: TopDashSpacing.xlg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: onCancel,
                icon: const Icon(Icons.close),
              ),
            ),
            const SizedBox(height: TopDashSpacing.md),
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
              l10n.quit,
              onPressed: onConfirm,
            ),
            const SizedBox(height: TopDashSpacing.sm),
            RoundedButton.text(
              l10n.cancel,
              backgroundColor: TopDashColors.seedWhite,
              onPressed: onCancel,
            ),
          ],
        ),
      ),
    );
  }
}
