import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_dash/how_to_play/how_to_play.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class HowToPlayPage extends StatelessWidget {
  const HowToPlayPage({super.key});

  factory HowToPlayPage.routeBuilder(_, __) {
    return const HowToPlayPage(
      key: Key('how_to_play'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TopDashColors.seedScrim,
      body: BlocProvider(
        create: (context) => HowToPlayBloc(),
        child: const HowToPlayView(),
      ),
    );
  }
}
