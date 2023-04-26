import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/leaderboard/initials_form/initials_form.dart';
import 'package:top_dash/share/share.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class InitialsFormView extends StatelessWidget {
  const InitialsFormView({super.key, this.shareHandPageData});

  static final focusNodes = List.generate(3, (_) => FocusNode());
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
                initials: state.initials.join(),
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
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _InitialFormField(
                  0,
                  focusNode: focusNodes[0],
                  onChanged: (index, value) =>
                      _onInitialChanged(context, value, index),
                ),
                const SizedBox(width: TopDashSpacing.sm),
                _InitialFormField(
                  1,
                  focusNode: focusNodes[1],
                  onChanged: (index, value) =>
                      _onInitialChanged(context, value, index),
                ),
                const SizedBox(width: TopDashSpacing.sm),
                _InitialFormField(
                  2,
                  focusNode: focusNodes[2],
                  onChanged: (index, value) =>
                      _onInitialChanged(context, value, index),
                ),
              ],
            ),
            const SizedBox(height: TopDashSpacing.xxlg),
            if (state.status.isInvalid)
              Text(l10n.enterInitialsError)
            else
              RoundedButton.text(
                l10n.enter,
                onPressed: () {
                  context
                      .read<InitialsFormBloc>()
                      .add(const InitialsSubmitted());
                },
              )
          ],
        );
      },
    );
  }

  void _onInitialChanged(BuildContext context, String value, int index) {
    context
        .read<InitialsFormBloc>()
        .add(InitialsChanged(initial: value, index: index));
    if (value.isNotEmpty) {
      focusNodes[index].unfocus();
      if (index < focusNodes.length - 1) {
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      }
    }
  }
}

class _InitialFormField extends StatelessWidget {
  const _InitialFormField(
    this.index, {
    required this.onChanged,
    required this.focusNode,
  });

  final int index;
  final void Function(int, String) onChanged;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 76,
      color: Colors.white,
      child: TextFormField(
        key: Key('initial_form_field_$index'),
        focusNode: focusNode,
        textInputAction: TextInputAction.next,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
          UpperCaseTextFormatter(),
          LengthLimitingTextInputFormatter(1)
        ],
        style: TopDashTextStyles.headlineH1.copyWith(
          color: TopDashColors.seedBlue,
        ),
        textCapitalization: TextCapitalization.characters,
        decoration: const InputDecoration(hintText: 'A'),
        textAlign: TextAlign.center,
        onChanged: (value) {
          onChanged(index, value);
        },
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
