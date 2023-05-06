// ignore_for_file: avoid_web_libraries_in_flutter, avoid_print
import 'dart:html';
import 'dart:js' as js;

import 'package:flop/app/app.dart';
import 'package:flop/bootstrap.dart';
import 'package:flutter/foundation.dart';

void main() {
  bootstrap(
    () => App(
      setAppCheckDebugToken: (appCheckDebugToken) {
        if (kDebugMode) {
          js.context['FIREBASE_APPCHECK_DEBUG_TOKEN'] = appCheckDebugToken;
        }
      },
      reload: () {
        window.location.reload();
      },
    ),
  );
}
