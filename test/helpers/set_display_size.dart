import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

extension IoFlipWidgetTester on WidgetTester {
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
    setDisplaySize(const Size(375, 600));
  }

  void setLargePhoneDisplaySize() {
    setDisplaySize(const Size(377, 812));
  }
}
