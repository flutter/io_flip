import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_dash/how_to_play/how_to_play.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class HowToPlayDialog extends StatelessWidget {
  const HowToPlayDialog({super.key});

  static Future<void> show(BuildContext context) async {
    return showGeneralDialog<void>(
      context: context,
      pageBuilder: (context, _, __) => const HowToPlayDialog(),
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
    return Dialog(
      insetPadding: const EdgeInsets.all(TopDashSpacing.sm),
      child: BlocProvider(
        create: (context) => HowToPlayBloc(),
        child: const HowToPlayView(),
      ),
    );
  }
}
