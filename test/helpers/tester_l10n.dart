import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip/l10n/l10n.dart';

extension TesterL10n on WidgetTester {
  AppLocalizations get l10n {
    final app = widget<MaterialApp>(find.byType(MaterialApp));

    final locale = app.locale ?? app.supportedLocales.first;

    return lookupAppLocalizations(locale);
  }
}
