import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

extension BuildContextMaybePop on BuildContext {
  void maybePop() {
    final router = GoRouter.of(this);
    if (router.canPop()) {
      router.pop();
    }
  }
}
