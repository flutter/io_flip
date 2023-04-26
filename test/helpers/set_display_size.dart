import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

extension TopDashWidgetTester on WidgetTester {
  void setDisplaySize(Size size) {
    view
      ..physicalSize = size
      ..devicePixelRatio = 1.0;

    addTearDown(() {
      view
        ..resetPhysicalSize()
        ..resetDevicePixelRatio();
    });
  }

  void setLandscapeDisplaySize() {
    setDisplaySize(const Size(1400, 800));
  }

  void setPortraitDisplaySize() {
    setDisplaySize(const Size(400, 800));
  }

  void setSmallestPhoneDisplaySize() {
    setDisplaySize(const Size(360, 600));
  }
}
