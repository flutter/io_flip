import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:provider/provider.dart';

/// {@template rounded_button}
/// I/O FLIP Rounded Button.
/// {@endtemplate}
class RoundedButton extends StatefulWidget {
  /// Basic [RoundedButton] with black shadow.
  /// Contains an [icon] as child
  RoundedButton.icon(
    IconData icon, {
    this.onPressed,
    this.onLongPress,
    super.key,
    this.backgroundColor = IoFlipColors.seedBlack,
    Color? foregroundColor = IoFlipColors.seedWhite,
    this.borderColor = IoFlipColors.seedPaletteNeutral40,
  }) : child = Icon(icon, color: foregroundColor);

  /// Basic [RoundedButton] with black shadow.
  /// Contains an [SvgPicture] as child
  RoundedButton.svg(
    String asset, {
    this.onPressed,
    this.onLongPress,
    super.key,
    this.backgroundColor = IoFlipColors.seedBlack,
    Color foregroundColor = IoFlipColors.seedWhite,
    this.borderColor = IoFlipColors.seedPaletteNeutral40,
  }) : child = SvgPicture.asset(
          asset,
          colorFilter: ColorFilter.mode(foregroundColor, BlendMode.srcIn),
        );

  /// Basic [RoundedButton] with black shadow.
  /// Contains a [text] as child
  RoundedButton.text(
    String text, {
    this.onPressed,
    this.onLongPress,
    super.key,
    this.backgroundColor = IoFlipColors.seedYellow,
    Color? foregroundColor = IoFlipColors.seedBlack,
    this.borderColor = IoFlipColors.seedBlack,
  }) : child = Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: IoFlipSpacing.sm,
          ),
          child: Text(
            text,
            style: IoFlipTextStyles.buttonLG.copyWith(color: foregroundColor),
          ),
        );

  /// Basic [RoundedButton] with black shadow.
  /// Contains a [image] and a [label] as children
  RoundedButton.image(
    Widget image, {
    String? label,
    this.onPressed,
    this.onLongPress,
    super.key,
    this.backgroundColor = IoFlipColors.seedBlack,
    Color? foregroundColor = IoFlipColors.seedWhite,
    this.borderColor = IoFlipColors.seedPaletteNeutral40,
  }) : child = Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: IoFlipSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              image,
              if (label != null)
                Padding(
                  padding: const EdgeInsets.only(left: IoFlipSpacing.md),
                  child: Text(
                    label,
                    style: IoFlipTextStyles.buttonLG
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

  /// On long pressed callback
  final GestureTapCallback? onLongPress;

  /// Button background color
  final Color backgroundColor;

  /// Button border color
  final Color borderColor;

  @override
  State<RoundedButton> createState() => RoundedButtonState();
}

/// I/O FLIP Rounded Button state.
class RoundedButtonState extends State<RoundedButton> {
  /// Whether the button is pressed or not.
  bool isPressed = false;

  /// Offset to move the button when pressed, and draw a shadow when not.
  static const Offset offset = Offset(-2, 2);

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  void _onPressed(BuildContext context) {
    context.read<UISoundAdapter>().playButtonSound();
    widget.onPressed?.call();
  }

  void _onLongPress(BuildContext context) {
    context.read<UISoundAdapter>().playButtonSound();
    widget.onLongPress?.call();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed == null ? null : () => _onPressed(context),
        onTapDown: (_) => setState(() => isPressed = true),
        onTapUp: (_) => setState(() => isPressed = false),
        onTapCancel: () => setState(() => isPressed = false),
        onLongPress:
            widget.onLongPress == null ? null : () => _onLongPress(context),
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
              padding: const EdgeInsets.all(IoFlipSpacing.md),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
