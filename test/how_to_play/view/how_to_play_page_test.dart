void main() {
  // group('HowToPlayPage', () {
  //   Widget buildSubject() => const Scaffold(body: HowToPlayPage());

  //   testWidgets('renders steps correctly', (tester) async {
  //     await tester.pumpApp(buildSubject());

  //     final l10n = tester.element(find.byType(HowToPlayPage)).l10n;

  //     final steps = <int, String>{
  //       1: l10n.howToPlayStepOneTitle,
  //       2: l10n.howToPlayStepTwoTitle,
  //       3: l10n.howToPlayStepThreeTitle,
  //       4: l10n.howToPlayStepFourTitle,
  //     };

  //     for (final step in steps.entries) {
  //       expect(find.text('${step.key}. ${step.value}'), findsOneWidget);
  //     }
  //   });

  //   testWidgets('can navigate to the how to play page', (tester) async {
  //     await tester.pumpApp(buildSubject());

  //     await tester.tap(find.text(tester.l10n.howToPlayButtonText));
  //     await tester.pumpAndSettle();

  //     expect(find.byType(HowToPlayPage), findsOneWidget);
  //   });
  // });
}
