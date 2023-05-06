// ignore_for_file: avoid_web_libraries_in_flutter, avoid_print
import 'dart:html';
import 'dart:js' as js;

import 'package:flop/app/app.dart';
import 'package:flop/bootstrap.dart';

void main() {
  bootstrap(
    () => App(
      setAppCheckDebugToken: (appCheckDebugToken) {
        js.context['FIREBASE_APPCHECK_DEBUG_TOKEN'] = appCheckDebugToken;
      },
      reload: () {
        window.location.reload();
      },
    ),
  );
}
