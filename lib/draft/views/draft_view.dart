import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_dash/draft/draft.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/style/palette.dart';

class DraftView extends StatelessWidget {
  const DraftView({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.read<Palette>();
    final bloc = context.watch<DraftBloc>();
    final state = bloc.state;
    final l10n = context.l10n;

    if (state.status == DraftStateStatus.cardFailed) {
      return Scaffold(
        backgroundColor: palette.backgroundMain,
        body: Center(
          child: Text(l10n.cardGenerationError),
        ),
      );
    }

    return BlocListener<DraftBloc, DraftState>(
      listenWhen: (old, current) => old.cards.length != state.cards.length,
      listener: (context, state) {
        if (state.status != DraftStateStatus.deckCompleted) {
          bloc.add(CardRequested());
        }
      },
      child: Scaffold(
        backgroundColor: palette.backgroundMain,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: palette.backgroundSettings,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 200,
                    height: 350,
                    child: const SizedBox(
                      width: 50,
                      height: 50,
                      child: Align(child: CircularProgressIndicator()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(l10n.generatingCards(state.cards.length + 1, 3)),
              const SizedBox(height: 16),
              if (state.status == DraftStateStatus.deckCompleted)
              ElevatedButton(
                onPressed: () {
                  // TODO navigate to the lobby when implemented
                },
                child: Text(l10n.play),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
