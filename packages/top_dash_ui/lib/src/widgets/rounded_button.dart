import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

/// {@template rounded_button}
/// Top Dash Rounded Button.
/// {@endtemplate}
class RoundedButton extends StatefulWidget {
  /// Basic [RoundedButton] with black shadow.
  /// Contains an [icon] as child
  RoundedButton.icon(
    IconData icon, {
    this.onPressed,
    super.key,
    this.backgroundColor = TopDashColors.seedBlack,
    Color? foregroundColor = TopDashColors.seedWhite,
    this.borderColor = TopDashColors.seedPaletteNeutral40,
  }) : child = Icon(icon, color: foregroundColor);

  /// Basic [RoundedButton] with black shadow.
  /// Contains a [text] as child
  RoundedButton.text(
    String text, {
    this.onPressed,
    super.key,
    this.backgroundColor = TopDashColors.seedYellow,
    Color? foregroundColor = TopDashColors.seedBlack,
    this.borderColor = TopDashColors.seedBlack,
  }) : child = Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: TopDashSpacing.sm,
          ),
          child: Text(
            text,
            style: TopDashTextStyles.buttonLG.copyWith(color: foregroundColor),
          ),
        );

  /// Basic [RoundedButton] with black shadow.
  /// Contains a [image] and a [label] as children
  RoundedButton.image(
    Image image, {
    String? label,
    this.onPressed,
    super.key,
    this.backgroundColor = TopDashColors.seedWhite,
    Color? foregroundColor = TopDashColors.seedBlack,
    this.borderColor = TopDashColors.seedBlack,
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
                    style: TopDashTextStyles.buttonLG
                        .copyWith(color: foregroundColor),
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

  /// Button border color
  final Color borderColor;

  @override
  State<RoundedButton> createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  bool isPressed = false;

  static const Offset offset = Offset(-2, 2);

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  void _onPressed(BuildContext context) {
    context.read<UISoundAdapter>().playButtonSound();
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed == null ? null : () => _onPressed(context),
        onTapDown: (_) => setState(() => isPressed = true),
        onTapUp: (_) => setState(() => isPressed = false),
        child: Transform.translate(
          offset: isPressed ? offset : Offset.zero,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                width: 2,
                color: widget.borderColor,
              ),
              color: widget.backgroundColor,
              boxShadow: [
                if (!isPressed)
                  const BoxShadow(
                    offset: offset,
                    spreadRadius: 1,
                  ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(TopDashSpacing.md),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
