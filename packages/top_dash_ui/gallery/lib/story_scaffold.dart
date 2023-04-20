import 'package:flutter/material.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class StoryScaffold extends StatelessWidget {
  const StoryScaffold({
    super.key,
    required this.title,
    required this.body,
    this.backgroundColor,
  });

  final String title;
  final Widget body;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(title),
        titleTextStyle: TopDashTextStyles.mobile.titleSmall,
      ),
      body: body,
    );
  }
}
