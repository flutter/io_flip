import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/leaderboard/initials_form/initials_form.dart';
import 'package:top_dash/share/share.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

// TODO(willhlas): update design.

class InitialsFormView extends StatelessWidget {
  const InitialsFormView({super.key, this.shareHandPageData});

  final ShareHandPageData? shareHandPageData;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<InitialsFormBloc, InitialsFormState>(
      listener: (context, state) {
        if (state.status == InitialsFormStatus.success) {
          if (shareHandPageData != null) {
            GoRouter.of(context).goNamed(
              'share_hand',
              extra: ShareHandPageData(
                initials: state.initials,
                wins: shareHandPageData!.wins,
                deckId: shareHandPageData!.deckId,
                deck: shareHandPageData!.deck,
              ),
            );
          } else {
            GoRouter.of(context).go('/');
          }
        }
      },
      builder: (context, state) {
        if (state.status == InitialsFormStatus.failure) {
          return const Center(child: Text('Error submitting initials'));
        }
        final String? errorText;
        if (state.status.isBlacklisted) {
          errorText = l10n.blacklistedInitialsError;
        } else if (state.status.isInvalid) {
          errorText = l10n.enterInitialsError;
        } else {
          errorText = null;
        }

        return Column(
          children: [
            Container(
              constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
              child: TextFormField(
                textInputAction: TextInputAction.go,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                  UpperCaseTextFormatter(),
                  LengthLimitingTextInputFormatter(3)
                ],
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  hintText: 'AAA',
                  errorText: errorText,
                ),
                textAlign: TextAlign.center,
                onChanged: (value) {
                  context
                      .read<InitialsFormBloc>()
                      .add(InitialsChanged(initials: value));
                },
              ),
            ),
            const SizedBox(height: TopDashSpacing.xxlg),
            FilledButton(
              onPressed: () {
                context.read<InitialsFormBloc>().add(InitialsSubmitted());
              },
              child: Text(l10n.enter),
            )
          ],
        );
      },
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
