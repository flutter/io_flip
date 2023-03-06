import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/draft/draft.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class DraftView extends StatelessWidget {
  const DraftView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<DraftBloc>();
    final state = bloc.state;
    final l10n = context.l10n;

    if (state.status == DraftStateStatus.deckFailed) {
      return Scaffold(
        backgroundColor: TopDashColors.backgroundMain,
        body: Center(
          child: Text(l10n.cardGenerationError),
        ),
      );
    }

    if (state.status == DraftStateStatus.deckLoading ||
        state.status == DraftStateStatus.initial) {
      return const Scaffold(
        backgroundColor: TopDashColors.backgroundMain,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final translateTween = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 80),
    );

    final scaleTween = Tween<double>(
      begin: 1,
      end: .8,
    );

    return Scaffold(
      backgroundColor: TopDashColors.backgroundMain,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                for (var i = state.cards.length - 1; i >= 0; i--)
                  Transform.translate(
                    offset: translateTween.transform(
                      (i + 1) / state.cards.length,
                    ),
                    child: Transform.scale(
                      scale: scaleTween.transform(
                        (i + 1) / state.cards.length,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: state.cards[i].rarity
                              ? Colors.yellow.shade200
                              : TopDashColors.backgroundSettings,
                          border: Border.all(
                            width: 2,
                            color: Colors.blue.shade100,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 200,
                        height: 350,
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            Text(state.cards[i].name),
                            const SizedBox(height: 8),
                            Image.network(
                              state.cards[i].image,
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Power: ${state.cards[i].power}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 60),
            if (state.status == DraftStateStatus.deckSelected)
              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).goNamed(
                    'match_making',
                    queryParams: {
                      'cardId':
                          state.selectedCards.map((card) => card.id).toList(),
                    },
                  );
                },
                child: Text(l10n.play),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      bloc.add(const NextCard());
                    },
                    child: Text(l10n.nextCard),
                  ),
                  ElevatedButton(
                    onPressed: state.selectedCards.contains(state.cards.last)
                        ? null
                        : () {
                            bloc.add(const SelectCard());
                          },
                    child: Text(l10n.useCard),
                  ),
                ],
              ),
            const SizedBox(height: 60),
            Column(
              children: [
                for (final card in state.selectedCards)
                  Text(
                    '${card.name}: ${card.power}',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
