import 'package:flutter/material.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:styled_text/styled_text.dart';

class HowToPlayStyledText extends StatelessWidget {
  const HowToPlayStyledText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return StyledText(
      text: text,
      style: textStyle,
      tags: textTags(),
      textAlign: TextAlign.center,
    );
  }

  TextStyle get textStyle => IoFlipTextStyles.mobileH4Light;

  Map<String, StyledTextTagBase> textTags() {
    return {
      'yellow': StyledTextTag(
        style: const TextStyle(color: IoFlipColors.seedYellow),
      ),
      'lightblue': StyledTextTag(
        style: const TextStyle(color: IoFlipColors.seedPaletteLightBlue80),
      ),
      'green': StyledTextTag(
        style: const TextStyle(color: IoFlipColors.seedGreen),
      ),
      'red': StyledTextTag(
        style: const TextStyle(color: IoFlipColors.seedRed),
      ),
      'blue': StyledTextTag(
        style: const TextStyle(color: IoFlipColors.seedBlue),
      ),
    };
  }
}
