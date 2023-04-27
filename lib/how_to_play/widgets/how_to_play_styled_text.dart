import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

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

  TextStyle get textStyle => TopDashTextStyles.mobileH4Light;

  Map<String, StyledTextTagBase> textTags() {
    return {
      'yellow': StyledTextTag(
        style: const TextStyle(color: TopDashColors.seedYellow),
      ),
      'lightblue': StyledTextTag(
        style: const TextStyle(color: TopDashColors.seedPaletteLightBlue80),
      ),
      'green': StyledTextTag(
        style: const TextStyle(color: TopDashColors.seedGreen),
      ),
      'red': StyledTextTag(
        style: const TextStyle(color: TopDashColors.seedRed),
      ),
      'blue': StyledTextTag(
        style: const TextStyle(color: TopDashColors.seedBlue),
      ),
    };
  }
}
