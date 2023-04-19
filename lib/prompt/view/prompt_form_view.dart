import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:game_domain/game_domain.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class PromptFormView extends StatefulWidget {
  const PromptFormView({
    required this.title,
    required this.subtitle,
    required this.hint,
    required this.buttonIcon,
    this.isLastOfFlow = false,
    super.key,
  });

  final String title;
  final String subtitle;
  final String hint;
  final IconData buttonIcon;
  final bool isLastOfFlow;

  @override
  State<PromptFormView> createState() => _PromptFormViewState();
}

class _PromptFormViewState extends State<PromptFormView> {
  var _text = '';

  static const _gap = SizedBox(height: TopDashSpacing.spaceUnit);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.title,
          style: TopDashTextStyles.headlineH4Light,
        ),
        _gap,
        Text(widget.subtitle, style: TopDashTextStyles.bodyLG),
        _gap,
        Container(
          constraints: const BoxConstraints(minWidth: 100, maxWidth: 400),
          child: TextFormField(
            onChanged: (entry) => setState(() => _text = entry),
            onFieldSubmitted: _onSubmit,
            style: TopDashTextStyles.mobileH1,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TopDashTextStyles.mobileH1
                  .copyWith(color: TopDashColors.seedGrey70),
            ),
          ),
        ),
        _gap,
        RoundedButton.icon(
          widget.buttonIcon,
          onPressed: () => _onSubmit(_text),
        ),
      ],
    );
  }

  void _onSubmit(String field) {
    // TODO(hugo): check in whitelist if entry is valid
    widget.isLastOfFlow
        ? context
            .flow<Prompt>()
            .complete((data) => data.copyWithNewAttribute(_text))
        : context
            .flow<Prompt>()
            .update((data) => data.copyWithNewAttribute(_text));
  }
}
