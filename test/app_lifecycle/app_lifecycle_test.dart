import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_flip/app_lifecycle/app_lifecycle.dart';

void main() {
  group('AppLifecycleObserver', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppLifecycleObserver(
              child: Text('test'),
            ),
          ),
        ),
      );

      expect(find.text('test'), findsOneWidget);
    });

    testWidgets('listens to the app', (tester) async {
      final key = GlobalKey<AppLifecycleObserverState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppLifecycleObserver(
              key: key,
              child: const Text('test'),
            ),
          ),
        ),
      );

      final state = key.currentState!;
      var lifecycleState = state.lifecycleListenable.value;
      expect(lifecycleState, equals(AppLifecycleState.inactive));

      state.lifecycleListenable.addListener(() {
        lifecycleState = state.lifecycleListenable.value;
      });

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      expect(lifecycleState, equals(AppLifecycleState.resumed));
    });
  });
}
