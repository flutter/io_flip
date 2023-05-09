import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

import 'game/game.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (bloc is GameBloc) {
      print(change.currentState);
      print(change.nextState);
    }
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

typedef BootstrapBuilder = FutureOr<Widget> Function(
  FirebaseFirestore firestore,
  FirebaseAuth firebaseAuth,
  FirebaseAppCheck appCheck,
);

Future<void> bootstrap(BootstrapBuilder builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();
  recordStackTraceAtLevel = Level.ALL;

  await runZonedGuarded(
    () async {
      if (kReleaseMode) {
        // Don't log anything below warnings in production.
        Logger.root.level = Level.WARNING;
      }
      Logger.root.onRecord.listen((record) {
        debugPrint('${record.level.name}: ${record.time}: '
            '${record.loggerName}: '
            '${record.message}');
      });

      runApp(
        await builder(
          FirebaseFirestore.instance,
          FirebaseAuth.instance,
          FirebaseAppCheck.instance,
        ),
      );
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
