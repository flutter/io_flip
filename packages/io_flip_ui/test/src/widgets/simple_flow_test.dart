import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip_ui/src/widgets/simple_flow.dart';

class _TestFlowData extends Equatable {
  const _TestFlowData(
    this.value1,
    this.value2,
    this.value3,
  );

  // text field input for

  final int? value1;
  final int? value2;
  final int? value3;

  _TestFlowData copyWith({
    int? value1,
    int? value2,
    int? value3,
  }) {
    return _TestFlowData(
      value1 ?? this.value1,
      value2 ?? this.value2,
      value3 ?? this.value3,
    );
  }

  @override
  List<Object?> get props => [value1, value2, value3];
}

void main() {
  group('SimpleFlow', () {
    group('Follows a normal flow', () {
      testWidgets('steps and complete a flow', (tester) async {
        late final _TestFlowData completedData;
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: SimpleFlow(
              initialData: () => const _TestFlowData(null, null, null),
              onComplete: (data) {
                completedData = data;
              },
              stepBuilder: (context, data, _) {
                return Column(
                  children: [
                    Text(
                      'v1:${data.value1};v2:${data.value2};v3:${data.value3}',
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (data.value1 == null) {
                          return context.updateFlow<_TestFlowData>(
                            (current) => current.copyWith(value1: 1),
                          );
                        }

                        if (data.value2 == null) {
                          return context.updateFlow<_TestFlowData>(
                            (current) => current.copyWith(value2: 2),
                          );
                        }

                        return context.completeFlow<_TestFlowData>(
                          (current) => current.copyWith(value3: 3),
                        );
                      },
                      child: const Text('Update'),
                    ),
                  ],
                );
              },
            ),
          ),
        );

        expect(find.text('v1:null;v2:null;v3:null'), findsOneWidget);

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('v1:1;v2:null;v3:null'), findsOneWidget);

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('v1:1;v2:2;v3:null'), findsOneWidget);

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.text('v1:1;v2:2;v3:3'), findsOneWidget);

        expect(completedData, const _TestFlowData(1, 2, 3));
      });

      testWidgets('forwards child widget', (widgetTester) async {
        await widgetTester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: SimpleFlow(
              initialData: () => const _TestFlowData(null, null, null),
              onComplete: (_) {},
              stepBuilder: (_, __, child) => child!,
              child: const Text('Child'),
            ),
          ),
        );

        expect(find.text('Child'), findsOneWidget);
      });
    });
  });
}
