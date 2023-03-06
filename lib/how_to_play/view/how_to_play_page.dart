import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/l10n/l10n.dart';

// TODO(willhlas): update hard coded values with values from the
//  design system once it is complete.

class HowToPlayPage extends StatelessWidget {
  const HowToPlayPage({super.key});

  factory HowToPlayPage.routeBuilder(_, __) {
    return const HowToPlayPage(
      key: Key('how_to_play'),
    );
  }

  static const _gap = SizedBox(height: 16);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    final steps = <int, String>{
      1: l10n.howToPlayStepOneTitle,
      2: l10n.howToPlayStepTwoTitle,
      3: l10n.howToPlayStepThreeTitle,
      4: l10n.howToPlayStepFourTitle,
    };

    return Scaffold(
      body: SingleChildScrollView(
        child: Align(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 32),
                    child: _Header(),
                  ),
                  _gap,
                  Text(
                    l10n.howToPlayTitle,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  _gap,
                  for (final step in steps.entries) ...[
                    Text(
                      '${step.key}. ${step.value}',
                      style: textTheme.titleMedium,
                    ),
                    _gap,
                  ],
                  Padding(
                    padding: const EdgeInsets.only(top: 56, bottom: 64),
                    child: Column(
                      children: [
                        Text(
                          l10n.howToPlayTip,
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.howToPlayTipEncouragement,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => GoRouter.of(context).go('/draft'),
                    child: Text(l10n.howToPlayButtonText),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final style = Theme.of(context).textTheme.titleLarge;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: '${l10n.ioBash} ',
            style: style?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: l10n.howToPlayHeader,
            style: style,
          )
        ],
      ),
    );
  }
}
