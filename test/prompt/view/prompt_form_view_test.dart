// ignore_for_file: prefer_const_constructors

import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:top_dash/prompt/prompt.dart';

import '../../helpers/helpers.dart';

class _FakePromptFlowController extends FakeFlowController<Prompt> {
  _FakePromptFlowController() : super(const Prompt());
}

const _itemsList = ['Archer', 'Magician', 'Climber'];

void main() {
  late FakeFlowController<Prompt> flowController;

  setUp(() {
    flowController = _FakePromptFlowController();
  });

  group('PromptFormView', () {
    testWidgets('flow updates correctly', (tester) async {
      await tester.pumpSubject(flowController);

      await tester.tap(find.text(tester.l10n.select.toUpperCase()));

      await tester.pumpAndSettle();

      expect(
        flowController.state,
        equals(Prompt(characterClass: _itemsList[0])),
      );
    });

    testWidgets(
      'flow updates correctly when changing selection',
      (tester) async {
        await tester.pumpSubject(flowController);

        await tester.drag(
          find.byType(ListWheelScrollView),
          Offset(0, -PromptFormView.itemExtent),
        );
        await tester.tap(find.text(tester.l10n.select.toUpperCase()));

        await tester.pumpAndSettle();

        expect(
          flowController.state,
          equals(Prompt(characterClass: _itemsList[1])),
        );
      },
    );

    testWidgets(
      'list snaps and selects correct item',
      (tester) async {
        await tester.pumpSubject(flowController);

        await tester.drag(
          find.byType(ListWheelScrollView),
          Offset(0, -PromptFormView.itemExtent * 1.6),
        );
        await tester.tap(find.text(tester.l10n.select.toUpperCase()));

        await tester.pumpAndSettle();

        expect(
          flowController.state,
          equals(Prompt(characterClass: _itemsList[2])),
        );
      },
    );

    testWidgets('flow completes correctly', (tester) async {
      await tester.pumpSubject(flowController, isLast: true);

      await tester.tap(find.text(tester.l10n.select.toUpperCase()));
      await tester.pumpAndSettle();

      expect(
        flowController.state,
        equals(Prompt(characterClass: _itemsList[0])),
      );
      expect(flowController.completed, isTrue);
    });
  });
}

extension PromptFormViewTest on WidgetTester {
  Future<void> pumpSubject(
    FlowController<Prompt> flowController, {
    bool isLast = false,
  }) {
    return pumpApp(
      Scaffold(
        body: FlowBuilder<Prompt>(
          controller: flowController,
          onGeneratePages: (data, pages) {
            return [
              MaterialPage(
                child: PromptFormView(
                  title: '',
                  initialItem: 0,
                  itemsList: _itemsList,
                  isLastOfFlow: isLast,
                ),
              )
            ];
          },
        ),
      ),
    );
  }
}
