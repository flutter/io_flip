import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class LeaderboardEntryView extends StatelessWidget {
  const LeaderboardEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    const white = TopDashColors.white;

    return Scaffold(
      backgroundColor: TopDashColors.backgroundLeaderboardEntry,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TopDashSpacing.xxlg),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.youMadeItToTheLeaderboard,
                style: textTheme.titleMedium?.copyWith(
                  color: white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                l10n.enterYourInitials,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: white,
                ),
              ),
              const SizedBox(height: TopDashSpacing.xxlg),
              const _InitialsForm()
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

  static const initialsBlacklist = [
    'FUK',
    'FUC',
    'COK',
    'DIK',
    'KKK',
    'SHT',
    'CNT',
    'ASS',
    'CUM',
    'FAG',
    'GAY',
    'GOD',
    'JEW',
    'SEX',
    'TIT',
    'WTF',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    const white = TopDashColors.white;
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
                    !_initialRegex.hasMatch(inputValue) ||
                    initialsBlacklist.contains(inputValue)) {
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
              cursorColor: white,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: white),
                ),
                hintText: 'AAA',
                hintStyle: TextStyle(color: white),
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(color: white),
            ),
          ),
          const SizedBox(height: TopDashSpacing.xxlg),
          OutlinedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {}
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: white),
              foregroundColor: white,
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
