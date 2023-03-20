import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/match_making/match_making.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class MatchMakingView extends StatelessWidget {
  const MatchMakingView({
    super.key,
    Future<void> Function(ClipboardData) setClipboardData = Clipboard.setData,
  }) : _setClipboardData = setClipboardData;

  final Future<void> Function(ClipboardData) _setClipboardData;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MatchMakingBloc, MatchMakingState>(
      listener: (previous, current) {
        if (current.status == MatchMakingStatus.completed) {
          context.go('/game/${current.match?.id}/${current.isHost}');
        }
      },
      builder: (context, state) {
        if (state.status == MatchMakingStatus.processing ||
            state.status == MatchMakingStatus.initial) {
          return Scaffold(
            backgroundColor: TopDashColors.backgroundMain,
            body: Center(
              child: Column(
                children: [
                  const CircularProgressIndicator(),
                  if (state.match?.inviteCode != null)
                    ElevatedButton(
                      onPressed: () {
                        _setClipboardData(
                          ClipboardData(text: state.match?.inviteCode),
                        );
                      },
                      child: const Text('Copy invite code'),
                    ),
                ],
              ),
            ),
          );
        }

        if (state.status == MatchMakingStatus.timeout) {
          return const Scaffold(
            backgroundColor: TopDashColors.backgroundMain,
            body: Center(
              child: Text('Match making timed out, sorry!'),
            ),
          );
        }

        if (state.status == MatchMakingStatus.failed) {
          return const Scaffold(
            backgroundColor: TopDashColors.backgroundMain,
            body: Center(
              child: Text('Match making failed, sorry!'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: TopDashColors.backgroundMain,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Host:'),
                Text(state.match?.host ?? ''),
                const Text('Guest:'),
                Text(state.match?.guest ?? ''),
              ],
            ),
          ),
        );
      },
    );
  }
}
