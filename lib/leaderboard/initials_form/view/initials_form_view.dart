import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/leaderboard/initials_form/initials_form.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

// TODO(willhlas): update design.

class InitialsFormView extends StatelessWidget {
  const InitialsFormView({super.key, this.route});

  final void Function(BuildContext, String)? route;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<InitialsFormBloc, InitialsFormState>(
      listener: (context, state) {
        if (state.status == InitialsFormStatus.success) {
          if (route == null) {
            GoRouter.of(context).go('/');
          } else {
            route!(context, state.initials);
          }
        }
      },
      builder: (context, state) {
        if (state.status == InitialsFormStatus.failure) {
          return const Center(child: Text('Error submitting initials'));
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
                  errorText:
                      state.status.isInvalid ? l10n.enterInitialsError : null,
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
