import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/leaderboard/initials_form/initials_form.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class InitialsFormView extends StatelessWidget {
  const InitialsFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const white = TopDashColors.white;
    return BlocBuilder<InitialsFormBloc, InitialsFormState>(
      builder: (context, state) {
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
                cursorColor: white,
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: white),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: white),
                  ),
                  hintText: 'AAA',
                  hintStyle: const TextStyle(color: white),
                  errorText: state.initials.isNotValid
                      ? state.initials.displayError?.text(l10n)
                      : null,
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(color: white),
                onChanged: (value) {
                  context
                      .read<InitialsFormBloc>()
                      .add(InitialsChanged(initials: value));
                },
              ),
            ),
            const SizedBox(height: TopDashSpacing.xxlg),
            OutlinedButton(
              onPressed: () {
                if (Formz.validate(state.inputs)) {}
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: white),
                foregroundColor: white,
              ),
              child: Text(l10n.continueButton.toUpperCase()),
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
