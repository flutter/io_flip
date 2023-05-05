import 'package:flutter/widgets.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

///
/// {@template io_flip_error_view}
/// IO Flip error view typically shown on an error state to go back
/// to the main page.
/// {@endtemplate}
class IoFlipErrorView extends StatelessWidget {
  /// {@macro io_flip_error_view}
  const IoFlipErrorView({
    required this.text,
    required this.buttonText,
    required this.onPressed,
    super.key,
  });

  /// Text for the center of the view.
  final String text;

  /// Text for the button.
  final String buttonText;

  /// Function triggered when tapping the button.
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: IoFlipTextStyles.mobileH1,
          ),
          const SizedBox(height: IoFlipSpacing.xxlg),
          RoundedButton.text(
            buttonText,
            backgroundColor: IoFlipColors.seedBlack,
            foregroundColor: IoFlipColors.seedWhite,
            borderColor: IoFlipColors.seedPaletteNeutral40,
            onPressed: onPressed,
          )
        ],
      ),
    );
  }
}
