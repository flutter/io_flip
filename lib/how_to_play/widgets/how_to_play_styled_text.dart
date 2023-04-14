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
      style: textStyle(context),
      tags: textTags(context),
      textAlign: TextAlign.center,
    );
  }

  bool isScreenSmall(BuildContext context) =>
      MediaQuery.of(context).size.width < TopDashBreakpoints.medium;

  TextStyle textStyle(BuildContext context) {
    return isScreenSmall(context)
        ? TopDashTextStyles.headlineMobileH4Light
        : TopDashTextStyles.headlineH4Light;
  }

  Map<String, StyledTextTagBase> textTags(BuildContext context) {
    return {
      'bold': StyledTextTag(
        style: isScreenSmall(context)
            ? TopDashTextStyles.headlineMobileH4
            : TopDashTextStyles.headlineH4,
      ),
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
