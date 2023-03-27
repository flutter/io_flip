import 'package:flutter/material.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

/// {@template rounded_button}
/// Top Dash Rounded Button.
/// {@endtemplate}
class RoundedButton extends StatelessWidget {
  /// Basic [RoundedButton] with black shadow shadow.
  const RoundedButton({
    required this.child,
    required this.onPressed,
    super.key,
    this.backgroundColor = TopDashColors.mainBlue,
  });

  /// Button Child
  final Widget child;

  /// On pressed callback
  final GestureTapCallback onPressed;

  /// Button background color
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(width: 2),
          color: backgroundColor,
          boxShadow: const [
            BoxShadow(
              offset: Offset(2, 2),
              spreadRadius: 1,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(TopDashSpacing.md),
          child: child,
        ),
      ),
    );
  }
}
