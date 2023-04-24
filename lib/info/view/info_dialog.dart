import 'package:flutter/material.dart';
import 'package:top_dash/info/info.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({super.key});

  static Future<void> show(BuildContext context) async {
    return showGeneralDialog<void>(
      context: context,
      pageBuilder: (context, _, __) => const InfoDialog(),
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

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      insetPadding: EdgeInsets.all(TopDashSpacing.sm),
      child: InfoView(),
    );
  }
}
