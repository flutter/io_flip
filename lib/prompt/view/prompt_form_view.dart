import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_flip/audio/audio.dart';
import 'package:io_flip/l10n/l10n.dart';
import 'package:io_flip/prompt/prompt.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

class PromptFormView extends StatefulWidget {
  const PromptFormView({
    required this.title,
    required this.itemsList,
    required this.initialItem,
    this.isLastOfFlow = false,
    super.key,
  });

  final String title;
  final List<String> itemsList;
  final int initialItem;
  final bool isLastOfFlow;

  static const itemExtent = 48.0;

  @override
  State<PromptFormView> createState() => _PromptFormViewState();
}

class _PromptFormViewState extends State<PromptFormView> {
  late int selectedIndex;

  static const _gap = SizedBox(height: IoFlipSpacing.xxxlg);

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialItem;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: IoFlipSpacing.xxlg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: IoFlipSpacing.lg),
          child: Text(
            widget.title,
            style: IoFlipTextStyles.headlineH4Light,
            textAlign: TextAlign.center,
          ),
        ),
        _gap,
        Expanded(
          child: Stack(
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(PromptFormView.itemExtent),
                    color: IoFlipColors.seedYellow,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 6,
                  ),
                  child: Text(
                    selectedText,
                    style: IoFlipTextStyles.mobileH3.copyWith(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  foregroundDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        backgroundColor,
                        backgroundColor.withOpacity(0),
                        backgroundColor.withOpacity(0),
                        backgroundColor,
                      ],
                      stops: const [0, .05, .95, 1],
                    ),
                  ),
                  child: ListWheelScrollView.useDelegate(
                    controller: FixedExtentScrollController(
                      initialItem: widget.initialItem,
                    ),
                    diameterRatio: 500, // flat list in practice
                    scrollBehavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    itemExtent: PromptFormView.itemExtent,
                    physics: const SnapItemScrollPhysics(
                      itemExtent: PromptFormView.itemExtent,
                    ),
                    onSelectedItemChanged: (index) {
                      setState(() => selectedIndex = index);
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (_, index) {
                        return Center(
                          child: Text(
                            widget.itemsList[index],
                            style: IoFlipTextStyles.mobileH3.copyWith(
                              color: index == selectedIndex
                                  ? IoFlipColors.seedBlack
                                  : IoFlipColors.seedGrey70,
                            ),
                          ),
                        );
                      },
                      childCount: widget.itemsList.length,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        _gap,
        IoFlipBottomBar(
          leading: const AudioToggleButton(),
          middle: RoundedButton.text(
            l10n.select.toUpperCase(),
            onPressed: () => _onSubmit(selectedText),
          ),
        ),
      ],
    );
  }

  String get selectedText => widget.itemsList[selectedIndex];

  void _onSubmit(String field) {
    widget.isLastOfFlow
        ? context.completeFlow<Prompt>(
            (data) => data.copyWithNewAttribute(selectedText),
          )
        : context.updateFlow<Prompt>(
            (data) => data.copyWithNewAttribute(selectedText),
          );
  }
}
