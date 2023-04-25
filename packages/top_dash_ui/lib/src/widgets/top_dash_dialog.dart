import 'package:flutter/material.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

/// {@template top_dash_dialog}
/// Top Dash themed dialog.
/// {@endtemplate}
class TopDashDialog extends StatelessWidget {
  /// {@macro top_dash_dialog}
  const TopDashDialog({
    required this.child,
    super.key,
  });

  /// Shows the dialog.
  static Future<void> show(BuildContext context, Widget child) async {
    return showGeneralDialog<void>(
      context: context,
      pageBuilder: (context, _, __) => TopDashDialog(child: child),
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(TopDashSpacing.sm),
      child: child,
    );
  }
}
