import 'package:flutter/material.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

/// {@template top_dash_dialog}
/// Top Dash themed dialog.
/// {@endtemplate}
class TopDashDialog extends StatelessWidget {
  /// {@macro top_dash_dialog}
  const TopDashDialog({
    required this.child,
    this.showCloseButton = true,
    this.onClose,
    super.key,
  });

  /// Shows the dialog.
  static Future<void> show(
    BuildContext context, {
    required Widget child,
    bool showCloseButton = true,
    VoidCallback? onClose,
  }) async {
    return showGeneralDialog<void>(
      context: context,
      pageBuilder: (context, _, __) => TopDashDialog(
        showCloseButton: showCloseButton,
        onClose: onClose,
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = Curves.easeOutBack.transform(animation.value);
        final dy = (1 - curvedAnimation) * 40;
        return Opacity(
          opacity: Curves.easeOutQuart.transform(animation.value),
          child: Transform.translate(
            offset: Offset(0, dy),
            child: child,
          ),
        );
      },
    );
  }

  /// The child of the dialog.
  final Widget child;

  /// Whether to show the close button.
  ///
  /// Defaults to `true`.
  final bool showCloseButton;

  /// The callback to call when the close button is pressed.
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(TopDashSpacing.sm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(TopDashSpacing.lg),
        child: SingleChildScrollView(
          child: Container(
            width: 327,
            padding: const EdgeInsets.all(TopDashSpacing.lg),
            child: Column(
              children: [
                if (showCloseButton)
                  Align(
                    alignment: Alignment.centerRight,
                    child: CloseButton(
                      onPressed: onClose,
                      color: TopDashColors.seedWhite,
                    ),
                  ),
                const SizedBox(height: TopDashSpacing.lg),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
