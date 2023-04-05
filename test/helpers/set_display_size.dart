import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

extension TopDashWidgetTester on WidgetTester {
  void setDisplaySize(Size size) {
    binding.window.physicalSizeTestValue = size;
    binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      binding.window.clearPhysicalSizeTestValue();
      binding.window.clearDevicePixelRatioTestValue();
    });
  }

  void setLandscapeDisplaySize() {
    setDisplaySize(const Size(1400, 800));
  }

  void setPortraitDisplaySize() {
    setDisplaySize(const Size(400, 800));
  }
}
