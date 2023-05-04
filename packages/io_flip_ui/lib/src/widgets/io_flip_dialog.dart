import 'package:flutter/material.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

/// {@template io_flip_dialog}
/// IO FLIP themed dialog.
/// {@endtemplate}
class IoFlipDialog extends StatelessWidget {
  /// {@macro io_flip_dialog}
  const IoFlipDialog({
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
      pageBuilder: (context, _, __) => IoFlipDialog(
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
      insetPadding: const EdgeInsets.all(IoFlipSpacing.sm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(IoFlipSpacing.lg),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(IoFlipSpacing.lg),
              child: Column(
                children: [
                  if (showCloseButton)
                    Align(
                      alignment: Alignment.centerRight,
                      child: CloseButton(
                        onPressed: onClose,
                        color: IoFlipColors.seedWhite,
                      ),
                    ),
                  const SizedBox(height: IoFlipSpacing.lg),
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
