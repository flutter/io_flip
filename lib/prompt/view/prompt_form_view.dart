import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:game_domain/game_domain.dart';
import 'package:top_dash/audio/audio.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/prompt/prompt.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

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

  static const _gap = SizedBox(height: TopDashSpacing.xxxlg);

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialItem;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final viewPortHeight = MediaQuery.of(context).size.height;
    final isSmall = viewPortHeight < 700;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: TopDashSpacing.xxlg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TopDashSpacing.lg),
          child: Text(
            widget.title,
            style: TopDashTextStyles.headlineH4Light,
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
                    color: TopDashColors.seedYellow,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 6,
                  ),
                  child: Text(
                    selectedText,
                    style: TopDashTextStyles.mobileH3.copyWith(
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
                            style: TopDashTextStyles.mobileH3.copyWith(
                              color: index == selectedIndex
                                  ? TopDashColors.seedBlack
                                  : TopDashColors.seedGrey70,
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
        Container(
          padding: const EdgeInsets.all(TopDashSpacing.sm),
          height: isSmall ? 64 : 96,
          child: Stack(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: AudioToggleButton(),
              ),
              Center(
                child: RoundedButton.text(
                  l10n.select.toUpperCase(),
                  onPressed: () => _onSubmit(selectedText),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String get selectedText => widget.itemsList[selectedIndex];

  void _onSubmit(String field) {
    widget.isLastOfFlow
        ? context
            .flow<Prompt>()
            .complete((data) => data.copyWithNewAttribute(selectedText))
        : context
            .flow<Prompt>()
            .update((data) => data.copyWithNewAttribute(selectedText));
  }
}
