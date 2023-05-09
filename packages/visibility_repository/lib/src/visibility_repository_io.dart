import 'dart:async';

import 'package:visibility_repository/src/visibility_detector.dart';

/// Implementation of [VisibilityDetector] for non-web platforms.
class VisibilityDetectorImpl implements VisibilityDetector {
  // For now, we don't detect events except on web;
  @override
  Stream<bool> get visibility => Stream.value(true);
}
