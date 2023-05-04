import 'package:flutter/material.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

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
    this.isTransparent = false,
  });

  /// Shows the dialog.
  static Future<void> show(
    BuildContext context, {
    required Widget child,
    bool showCloseButton = true,
    VoidCallback? onClose,
    bool isTransparent = false,
  }) async {
    return showGeneralDialog<void>(
      context: context,
      pageBuilder: (context, _, __) => TopDashDialog(
        isTransparent: isTransparent,
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

  /// Sets the background of the dialog to be transparent.
  /// Defaults to `false`.
  final bool isTransparent;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: isTransparent ? Colors.transparent : null,
      insetPadding: const EdgeInsets.all(TopDashSpacing.sm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(TopDashSpacing.lg),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
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
      ),
    );
  }
}
