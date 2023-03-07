import 'dart:async';
import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
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
);

Future<void> bootstrap({
  required FirebaseOptions firebaseOptions,
  required BootstrapBuilder builder,
}) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  await Firebase.initializeApp(
    options: firebaseOptions,
  );

  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.signInAnonymously();

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

      WidgetsFlutterBinding.ensureInitialized();

      runApp(await builder(FirebaseFirestore.instance));
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
