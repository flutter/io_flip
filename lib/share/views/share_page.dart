import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/share/share.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

typedef ShareCallback = Future<void> Function(String url, {String? subject});

class SharePage extends StatelessWidget {
  const SharePage({
    super.key,
    this.nativeShare = Share.share,
  });

  factory SharePage.routeBuilder(_, __) {
    return const SharePage(
      key: Key('share_page'),
    );
  }

  // TODO(kirpal): Make these dynamic.
  static const shareUrl = 'https://google.com';
  static const shareText = 'Check out Top Dash!';

  final ShareCallback nativeShare;

  Future<void> _share(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      return nativeShare(shareUrl, subject: shareText);
    }

    return showDialog(
      context: context,
      builder: (context) => const ShareDialog(
        shareUrl: shareUrl,
        shareText: shareText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.l10n.sharePageTitle),
            const SizedBox(height: TopDashSpacing.lg),
            ElevatedButton(
              onPressed: () => _share(context),
              child: const Text('Share'),
            ),
            const SizedBox(height: TopDashSpacing.lg),
            ElevatedButton(
              onPressed: () => GoRouter.of(context).go('/'),
              child: const Text('Main Menu'),
            ),
          ],
        ),
      ),
    );
  }
}
