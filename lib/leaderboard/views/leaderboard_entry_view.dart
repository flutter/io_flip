import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/style/palette.dart';

// TODO(samobrien): update hard coded styles when style guides are added.

class LeaderboardEntryView extends StatelessWidget {
  const LeaderboardEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.read<Palette>();
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: palette.leaderboardEntry,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.youMadeItToTheLeaderboard,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                l10n.enterYourInitials,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 32),
              _InitialsForm()
            ],
          ),
        ),
      ),
    );
  }
}

class _InitialsForm extends StatefulWidget {
  const _InitialsForm();

  @override
  State<_InitialsForm> createState() => _InitialsFormState();
}

class _InitialsFormState extends State<_InitialsForm> {
  final _formKey = GlobalKey<FormState>();
  final _initialRegex = RegExp('[A-Z]{3}');
  bool isValidForm = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
            child: TextFormField(
              validator: (inputValue) {
                if (inputValue == null ||
                    inputValue.isEmpty ||
                    !_initialRegex.hasMatch(inputValue)) {
                  return l10n.enterInitialsError;
                }
                return null;
              },
              textInputAction: TextInputAction.go,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                UpperCaseTextFormatter(),
                LengthLimitingTextInputFormatter(3)
              ],
              textCapitalization: TextCapitalization.characters,
              cursorColor: Colors.white,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                hintText: 'AAA',
                hintStyle: TextStyle(color: Colors.white),
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 48),
          OutlinedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {}
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white),
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.continueButton.toUpperCase()),
          )
        ],
      ),
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
