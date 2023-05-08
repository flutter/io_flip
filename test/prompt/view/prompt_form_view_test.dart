// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_flip/prompt/prompt.dart';
import 'package:io_flip/settings/settings.dart';
import 'package:io_flip_ui/io_flip_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockSettingsController extends Mock implements SettingsController {}

const _itemsList = ['Archer', 'Magician', 'Climber'];

void main() {
  group('PromptFormView', () {
    testWidgets('flow updates correctly', (tester) async {
      late Prompt data;
      await tester.pumpSubject(onStep: (step) => data = step);

      await tester.tap(find.text(tester.l10n.select.toUpperCase()));

      await tester.pumpAndSettle();

      expect(data, equals(Prompt(characterClass: _itemsList[0])));
    });

    testWidgets(
      'flow updates correctly when changing selection',
      (tester) async {
        late Prompt data;
        await tester.pumpSubject(onStep: (step) => data = step);

        await tester.drag(
          find.byType(ListWheelScrollView),
          Offset(0, -PromptFormView.itemExtent),
        );
        await tester.tap(find.text(tester.l10n.select.toUpperCase()));

        await tester.pumpAndSettle();

        expect(data, equals(Prompt(characterClass: _itemsList[1])));
      },
    );

    testWidgets(
      'list snaps and selects correct item',
      (tester) async {
        late Prompt data;
        await tester.pumpSubject(onStep: (step) => data = step);

        await tester.drag(
          find.byType(ListWheelScrollView),
          Offset(0, -PromptFormView.itemExtent * 2.2),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text(tester.l10n.select.toUpperCase()));

        await tester.pumpAndSettle();

        expect(data, equals(Prompt(characterClass: _itemsList[2])));
      },
    );

    testWidgets(
      'taps item in list and is selected correctly',
      (tester) async {
        late Prompt data;
        await tester.pumpSubject(onStep: (step) => data = step);

        await tester.tap(find.text(_itemsList[2]));
        await tester.pumpAndSettle();
        await tester.tap(find.text(tester.l10n.select.toUpperCase()));
        await tester.pumpAndSettle();

        expect(data, equals(Prompt(characterClass: _itemsList[2])));
      },
    );

    testWidgets('flow completes correctly', (tester) async {
      late Prompt data;
      await tester.pumpSubject(onComplete: (step) => data = step, isLast: true);

      await tester.tap(find.text(tester.l10n.select.toUpperCase()));
      await tester.pumpAndSettle();

      expect(data, equals(Prompt(characterClass: _itemsList[0])));
    });
  });
}

extension PromptFormViewTest on WidgetTester {
  Future<void> pumpSubject({
    bool isLast = false,
    ValueChanged<Prompt>? onComplete,
    ValueChanged<Prompt>? onStep,
  }) {
    final SettingsController settingsController = _MockSettingsController();
    when(() => settingsController.muted).thenReturn(ValueNotifier(true));
    return pumpApp(
      Scaffold(
        body: SimpleFlow(
          initialData: Prompt.new,
          onComplete: onComplete ?? (_) {},
          stepBuilder: (context, data, _) {
            onStep?.call(data);
            return PromptFormView(
              title: '',
              initialItem: 0,
              itemsList: _itemsList,
              isLastOfFlow: isLast,
            );
          },
        ),
      ),
      settingsController: settingsController,
    );
  }
}
