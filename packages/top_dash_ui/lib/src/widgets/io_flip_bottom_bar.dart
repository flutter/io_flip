import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

/// [IoFlipBottomBar] is a layout helper to position 3 widgets or groups of
/// widgets along a horizontal axis. It is a modified version of flutter's
/// [NavigationToolbar]
///
/// The [leading] and [trailing] widgets occupy the edges of the widget with
/// reasonable size constraints while the [middle] widget occupies the remaining
/// space in either a center aligned or start aligned fashion.
class IoFlipBottomBar extends StatelessWidget {
  /// Creates a widget that lays out its children in a manner suitable for a
  /// toolbar.
  const IoFlipBottomBar({
    super.key,
    this.leading,
    this.middle,
    this.trailing,
    this.height,
  });

  /// The default height for the bar.
  static const double kDefaultHeight = 64;

  /// Widget to place at the start of the horizontal toolbar.
  final Widget? leading;

  /// Widget to place in the middle of the horizontal toolbar, occupying
  /// as much remaining space as possible.
  final Widget? middle;

  /// Widget to place at the end of the horizontal toolbar.
  final Widget? trailing;

  /// Bottom bar height.
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TopDashSpacing.sm),
      height: height ?? kDefaultHeight,
      child: CustomMultiChildLayout(
        delegate: ToolbarLayout(),
        children: <Widget>[
          if (leading != null)
            LayoutId(id: _ToolbarSlot.leading, child: leading!),
          if (middle != null) LayoutId(id: _ToolbarSlot.middle, child: middle!),
          if (trailing != null)
            LayoutId(id: _ToolbarSlot.trailing, child: trailing!),
        ],
      ),
    );
  }
}

enum _ToolbarSlot {
  leading,
  middle,
  trailing,
}

///
class ToolbarLayout extends MultiChildLayoutDelegate {
  ///
  ToolbarLayout();

  /// The default spacing around the middle widget.
  static const double kMiddleSpacing = 16;

  @override
  void performLayout(Size size) {
    var leadingWidth = 0.0;
    var trailingWidth = 0.0;

    if (hasChild(_ToolbarSlot.leading)) {
      final constraints = BoxConstraints.loose(size);
      final leadingSize = layoutChild(_ToolbarSlot.leading, constraints);
      const leadingX = 0.0;
      final leadingY = size.height - leadingSize.height;
      leadingWidth = leadingSize.width;
      positionChild(_ToolbarSlot.leading, Offset(leadingX, leadingY));
    }

    if (hasChild(_ToolbarSlot.trailing)) {
      final constraints = BoxConstraints.loose(size);
      final trailingSize = layoutChild(_ToolbarSlot.trailing, constraints);
      final trailingX = size.width - trailingSize.width;

      final trailingY = size.height - trailingSize.height;
      trailingWidth = trailingSize.width;
      positionChild(_ToolbarSlot.trailing, Offset(trailingX, trailingY));
    }

    if (hasChild(_ToolbarSlot.middle)) {
      final double maxWidth = math.max(
        size.width - leadingWidth - trailingWidth - kMiddleSpacing * 2.0,
        0,
      );
      final constraints =
          BoxConstraints.loose(size).copyWith(maxWidth: maxWidth);
      final middleSize = layoutChild(_ToolbarSlot.middle, constraints);

      final middleX = (size.width - middleSize.width) / 2.0;
      final middleY = size.height - middleSize.height;

      positionChild(_ToolbarSlot.middle, Offset(middleX, middleY));
    }
  }

  @override
  bool shouldRelayout(ToolbarLayout oldDelegate) {
    return false;
  }
}
