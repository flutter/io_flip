import 'package:flutter/widgets.dart';
import 'package:top_dash/gen/assets.gen.dart';
import 'package:top_dash/info/view/info_dialog.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class InfoButton extends StatelessWidget {
  const InfoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return RoundedButton.svg(
      key: const Key('info_button'),
      Assets.icons.info,
      onPressed: () => InfoDialog.show(context),
    );
  }
}
