import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:io_flip/l10n/l10n.dart';
import 'package:io_flip/leaderboard/initials_form/initials_form.dart';
import 'package:io_flip/share/share.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

const emptyCharacter = '\u200b';

class InitialsFormView extends StatefulWidget {
  const InitialsFormView({super.key, this.shareHandPageData});

  final ShareHandPageData? shareHandPageData;

  @override
  State<InitialsFormView> createState() => _InitialsFormViewState();
}

class _InitialsFormViewState extends State<InitialsFormView> {
  final focusNodes = List.generate(3, (_) => FocusNode());

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<InitialsFormBloc, InitialsFormState>(
      listener: (context, state) {
        if (state.status == InitialsFormStatus.success) {
          if (widget.shareHandPageData != null) {
            GoRouter.of(context).goNamed(
              'share_hand',
              extra: ShareHandPageData(
                initials: state.initials.join(),
                wins: widget.shareHandPageData!.wins,
                deck: widget.shareHandPageData!.deck,
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
                  key: ObjectKey(focusNodes[0]),
                  onChanged: (index, value) {
                    _onInitialChanged(context, value, index);
                  },
                  onBackspace: (index) {
                    _onInitialChanged(context, '', index, isBackspace: true);
                  },
                ),
                const SizedBox(width: IoFlipSpacing.sm),
                _InitialFormField(
                  1,
                  key: ObjectKey(focusNodes[1]),
                  focusNode: focusNodes[1],
                  onChanged: (index, value) {
                    _onInitialChanged(context, value, index);
                  },
                  onBackspace: (index) {
                    _onInitialChanged(context, '', index, isBackspace: true);
                  },
                ),
                const SizedBox(width: IoFlipSpacing.sm),
                _InitialFormField(
                  2,
                  key: ObjectKey(focusNodes[2]),
                  focusNode: focusNodes[2],
                  onChanged: (index, value) {
                    _onInitialChanged(context, value, index);
                  },
                  onBackspace: (index) {
                    _onInitialChanged(context, '', index, isBackspace: true);
                  },
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

  void _onInitialChanged(
    BuildContext context,
    String value,
    int index, {
    bool isBackspace = false,
  }) {
    var text = value;
    if (text == emptyCharacter) {
      text = '';
    }

    context
        .read<InitialsFormBloc>()
        .add(InitialsChanged(initial: text, index: index));

    if (text.isNotEmpty) {
      if (index < focusNodes.length - 1) {
        focusNodes[index].unfocus();
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      }
    } else if (index > 0) {
      if (isBackspace) {
        setState(() {
          focusNodes[index - 1] = FocusNode();
        });

        SchedulerBinding.instance.scheduleFrameCallback((timeStamp) {
          FocusScope.of(context).requestFocus(focusNodes[index - 1]);
        });
      }
    }
  }
}

class _InitialFormField extends StatefulWidget {
  const _InitialFormField(
    this.index, {
    required this.onChanged,
    required this.focusNode,
    required this.onBackspace,
    super.key,
  });

  final int index;
  final void Function(int, String) onChanged;
  final void Function(int) onBackspace;
  final FocusNode focusNode;

  @override
  State<_InitialFormField> createState() => _InitialFormFieldState();
}

class _InitialFormFieldState extends State<_InitialFormField> {
  late final TextEditingController controller =
      TextEditingController.fromValue(lastValue);

  bool hasFocus = false;
  TextEditingValue lastValue = const TextEditingValue(
    text: emptyCharacter,
    selection: TextSelection.collapsed(offset: 1),
  );

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(onFocusChanged);
  }

  void onFocusChanged() {
    if (mounted) {
      final hadFocus = hasFocus;
      final willFocus = widget.focusNode.hasPrimaryFocus;

      setState(() {
        hasFocus = willFocus;
      });

      if (!hadFocus && willFocus) {
        final text = controller.text;
        final selection = TextSelection.collapsed(offset: text.length);
        controller.selection = selection;
      }
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(onFocusChanged);
    controller.dispose();
    super.dispose();
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
        controller: controller,
        autofocus: widget.index == 0,
        focusNode: widget.focusNode,
        showCursor: false,
        textInputAction: TextInputAction.next,
        inputFormatters: [
          BackspaceFormatter(
            onBackspace: () => widget.onBackspace(widget.index),
          ),
          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
          UpperCaseTextFormatter(),
          JustOneCharacterFormatter((value) {
            widget.onChanged(widget.index, value);
          }),
          EmptyCharacterAtEndFormatter(),
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

class EmptyCharacterAtEndFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;

    var text = newText;
    var selection = newValue.selection;
    if (newText.isEmpty) {
      text = emptyCharacter;
      selection = const TextSelection.collapsed(offset: 1);
    }
    return TextEditingValue(
      text: text,
      selection: selection,
    );
  }
}

class BackspaceFormatter extends TextInputFormatter {
  BackspaceFormatter({
    required this.onBackspace,
  });

  final VoidCallback onBackspace;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final oldText = oldValue.text;
    final newText = newValue.text;

    // Heuristic for detecting backspace press on an empty field on mobile.
    if (oldText == emptyCharacter && newText.isEmpty) {
      onBackspace();
    }
    return newValue;
  }
}

class JustOneCharacterFormatter extends TextInputFormatter {
  JustOneCharacterFormatter(this.onSameValue);

  /// If after truncation the text is the same as the previous one,
  /// this callback will force an "onChange" behavior.
  final ValueChanged<String> onSameValue;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;

    var text = newText;
    var selection = newValue.selection;
    if (newText.length > 1) {
      text = newText.substring(newText.length - 1);
      selection = const TextSelection.collapsed(offset: 1);
      if (text == oldValue.text) {
        onSameValue(text);
      }
    }
    return TextEditingValue(
      text: text,
      selection: selection,
    );
  }
}
