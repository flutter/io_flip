import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// TODO(all): add links.

abstract class ExternalLinks {
  static const String googleIO = '';
  static const String privacyPolicy = 'https://policies.google.com/privacy';
  static const String termsOfService = 'https://policies.google.com/terms';
  static const String faq = '';
  static const String howItsMade = '';
  static const String openSourceCode = '';
}

Future<void> openLink(String url, {VoidCallback? onError}) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else if (onError != null) {
    onError();
  }
}
