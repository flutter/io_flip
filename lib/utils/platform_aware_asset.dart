import 'package:flutter/foundation.dart';

T platformAwareAsset<T>({
  required T desktop,
  required T mobile,
  bool isWeb = kIsWeb,
  TargetPlatform? overrideDefaultTargetPlatform,
}) {
  final platform = overrideDefaultTargetPlatform ?? defaultTargetPlatform;
  final isWebMobile = isWeb &&
      (platform == TargetPlatform.iOS || platform == TargetPlatform.android);

  return isWebMobile ? mobile : desktop;
}
