import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:top_dash_ui/top_dash_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ShareDialog extends StatelessWidget {
  const ShareDialog({
    required this.shareUrl,
    required this.shareText,
    this.urlLauncher = launchUrlString,
    super.key,
  });

  final String shareUrl;
  final String shareText;
  final AsyncValueSetter<String> urlLauncher;

  String get _twitterShareUrl =>
      'https://twitter.com/intent/tweet?url=$shareUrl&text=$shareText';

  String get _facebookShareUrl =>
      'https://www.facebook.com/sharer.php?u=$shareUrl&quote=$shareText';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(TopDashSpacing.xlg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => urlLauncher(_twitterShareUrl),
              child: const Text('Twitter'),
            ),
            TextButton(
              onPressed: () => urlLauncher(_facebookShareUrl),
              child: const Text('Facebook'),
            ),
          ],
        ),
      ),
    );
  }
}
