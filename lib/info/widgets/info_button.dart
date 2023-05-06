import 'package:flutter/widgets.dart';
import 'package:io_flip/gen/assets.gen.dart';
import 'package:io_flip/info/view/info_view.dart';
import 'package:io_flip_ui/io_flip_ui.dart';

class InfoButton extends StatelessWidget {
  const InfoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return RoundedButton.svg(
      key: const Key('info_button'),
      Assets.icons.info.keyName,
      onPressed: () => IoFlipDialog.show(
        context,
        child: const InfoView(),
      ),
    );
  }
}
