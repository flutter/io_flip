import 'dart:async';
import 'dart:html' as html;

import 'package:visibility_repository/src/visibility_detector.dart';

/// Implementation of [VisibilityDetector] for web.
class VisibilityDetectorImpl implements VisibilityDetector {
  late final StreamController<bool> _controller = StreamController(
    onListen: _subscribeToDocumentVisibility,
  );

  @override
  Stream<bool> get visibility => _controller.stream;

  void _subscribeToDocumentVisibility() {
    html.document.addEventListener(
      'visibilitychange',
      (html.Event event) {
        final hidden = html.document.hidden ?? true;
        _controller.add(!hidden);
      },
    );
  }
}
