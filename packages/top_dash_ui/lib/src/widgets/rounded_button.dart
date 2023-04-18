import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

/// {@template rounded_button}
/// Top Dash Rounded Button.
/// {@endtemplate}
class RoundedButton extends StatelessWidget {
  /// Basic [RoundedButton] with black shadow.
  /// Contains an [icon] as child
  const RoundedButton.icon(
    Icon icon, {
    this.onPressed,
    super.key,
    this.backgroundColor = TopDashColors.seedWhite,
  }) : child = icon;

  /// Basic [RoundedButton] with black shadow.
  /// Contains a [text] as child
  RoundedButton.text(
    String text, {
    this.onPressed,
    super.key,
    this.backgroundColor = TopDashColors.seedPaletteBlue70,
  }) : child = Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: TopDashSpacing.sm,
          ),
          child: Text(
            text,
            style: TopDashTextStyles.buttonLG.copyWith(
              color: TopDashColors.seedBlack,
            ),
          ),
        );

  /// Basic [RoundedButton] with black shadow.
  /// Contains a [image] and a [label] as children
  RoundedButton.image(
    Image image, {
    String? label,
    this.onPressed,
    super.key,
    this.backgroundColor = TopDashColors.seedPaletteBlue70,
  }) : child = Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: TopDashSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              image,
              if (label != null)
                Padding(
                  padding: const EdgeInsets.only(left: TopDashSpacing.md),
                  child: Text(
                    label,
                    style: TopDashTextStyles.buttonLG,
                  ),
                ),
            ],
          ),
        );

  /// Button Child
  final Widget child;

  /// On pressed callback
  final GestureTapCallback? onPressed;

  /// Button background color
  final Color backgroundColor;

  void _onPressed(BuildContext context) {
    context.read<UISoundAdaptater>().playButtonSound();
    onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed == null ? null : () => _onPressed(context),
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
      ),
    );
  }
}
