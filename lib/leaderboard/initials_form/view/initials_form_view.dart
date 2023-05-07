import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:io_flip/l10n/l10n.dart';
import 'package:io_flip/leaderboard/initials_form/initials_form.dart';
import 'package:io_flip/share/share.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

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
                deck: shareHandPageData!.deck,
              ),
            );
          } else {
            GoRouter.of(context).go('/');
          }
        }
        if (state.status == InitialsFormStatus.blacklisted) {
          focusNodes.last.requestFocus();
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
                const SizedBox(width: IoFlipSpacing.sm),
                _InitialFormField(
                  1,
                  focusNode: focusNodes[1],
                  onChanged: (index, value) =>
                      _onInitialChanged(context, value, index),
                ),
                const SizedBox(width: IoFlipSpacing.sm),
                _InitialFormField(
                  2,
                  focusNode: focusNodes[2],
                  onChanged: (index, value) =>
                      _onInitialChanged(context, value, index),
                ),
              ],
            ),
            const SizedBox(height: IoFlipSpacing.sm),
            if (state.status == InitialsFormStatus.blacklisted)
              Text(
                l10n.blacklistedErrorMessage,
                style: IoFlipTextStyles.bodyLG.copyWith(
                  color: IoFlipColors.seedRed,
                ),
              )
            else if (state.status.isInvalid)
              Text(l10n.enterInitialsError),
            const SizedBox(height: IoFlipSpacing.xxlg),
            RoundedButton.text(
              l10n.enter,
              onPressed: () {
                context.read<InitialsFormBloc>().add(const InitialsSubmitted());
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
    } else if (index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
  }
}

class _InitialFormField extends StatefulWidget {
  const _InitialFormField(
    this.index, {
    required this.onChanged,
    required this.focusNode,
  });

  final int index;
  final void Function(int, String) onChanged;
  final FocusNode focusNode;

  @override
  State<_InitialFormField> createState() => _InitialFormFieldState();
}

class _InitialFormFieldState extends State<_InitialFormField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<InitialsFormBloc>();
    final blacklisted = bloc.state.status == InitialsFormStatus.blacklisted;
    final decoration = BoxDecoration(
      color: widget.focusNode.hasPrimaryFocus
          ? IoFlipColors.seedPaletteNeutral20
          : IoFlipColors.seedBlack,
      border: Border.all(
        color: blacklisted
            ? IoFlipColors.seedRed
            : widget.focusNode.hasPrimaryFocus
                ? IoFlipColors.seedYellow
                : IoFlipColors.seedPaletteNeutral40,
        width: 2,
      ),
    );

    return Container(
      width: 64,
      height: 72,
      decoration: decoration,
      child: TextFormField(
        key: Key('initial_form_field_${widget.index}'),
        autofocus: widget.index == 0,
        focusNode: widget.focusNode,
        showCursor: false,
        textInputAction: TextInputAction.next,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
          UpperCaseTextFormatter(),
          LengthLimitingTextInputFormatter(1)
        ],
        style: IoFlipTextStyles.mobileH1.copyWith(
          color: blacklisted ? IoFlipColors.seedRed : IoFlipColors.seedYellow,
        ),
        textCapitalization: TextCapitalization.characters,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        textAlign: TextAlign.center,
        onChanged: (value) {
          widget.onChanged(widget.index, value);
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
