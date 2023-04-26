import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:go_router/go_router.dart';
import 'package:top_dash/audio/audio.dart';
import 'package:top_dash/draft/draft.dart';
import 'package:top_dash/how_to_play/how_to_play.dart';
import 'package:top_dash/l10n/l10n.dart';
import 'package:top_dash/match_making/match_making.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

typedef RouterNeglectCall = void Function(BuildContext, VoidCallback);

class DraftView extends StatelessWidget {
  const DraftView({
    super.key,
    RouterNeglectCall routerNeglectCall = Router.neglect,
  }) : _routerNeglectCall = routerNeglectCall;

  final RouterNeglectCall _routerNeglectCall;

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<DraftBloc>();
    final state = bloc.state;
    final l10n = context.l10n;

    if (state.status == DraftStateStatus.deckFailed) {
      return IoFlipScaffold(
        body: Center(
          child: Text(l10n.cardGenerationError),
        ),
      );
    }

    if (state.status == DraftStateStatus.deckLoading ||
        state.status == DraftStateStatus.initial) {
      return const IoFlipScaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return IoFlipScaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _DraftDeck(),
                  Flexible(
                    child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: TopDashSpacing.xxxlg,
                      ),
                    ),
                  ),
                  const _SelectedDeck(),
                ],
              ),
            ),
            _BottomBar(routerNeglectCall: _routerNeglectCall),
          ],
        ),
      ),
    );
  }
}

class _DraftDeck extends StatelessWidget {
  const _DraftDeck();

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<DraftBloc>();
    final state = bloc.state;

    final translateTween = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 80),
    );

    final scaleTween = Tween<double>(
      begin: 1,
      end: .8,
    );

    const cardSize = GameCardSize.lg();

    final bottomPadding = translateTween.transform(1).dy -
        ((cardSize.height * (1 - scaleTween.transform(1))) / 2);

    final showArrows = MediaQuery.of(context).size.width > 500;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showArrows) ...[
          IconButton(
            onPressed: () {
              bloc.add(const PreviousCard());
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: TopDashColors.seedWhite,
            ),
            iconSize: 20,
          ),
          const SizedBox(width: TopDashSpacing.xs),
        ],
        Padding(
          // Padding required to avoid widgets overlapping due to Stack child's
          // translations
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Stack(
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
                    child: Dismissible(
                      direction: i == 0
                          ? DismissDirection.horizontal
                          : DismissDirection.none,
                      key: ValueKey(state.cards[i].id),
                      onDismissed: (direction) {
                        bloc.add(const CardSwiped());
                      },
                      onUpdate: (details) {
                        bloc.add(CardSwipeStarted(details.progress));
                      },
                      child: Opacity(
                        opacity: i == 0 ? state.firstCardOpacity : 1,
                        child: GameCard(
                          image: state.cards[i].image,
                          name: state.cards[i].name,
                          description: state.cards[i].description,
                          power: state.cards[i].power,
                          suitName: state.cards[i].suit.name,
                          isRare: state.cards[i].rarity,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (showArrows) ...[
          const SizedBox(width: TopDashSpacing.xs),
          IconButton(
            onPressed: () {
              bloc.add(const NextCard());
            },
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: TopDashColors.seedWhite,
            ),
            iconSize: 20,
          ),
        ],
      ],
    );
  }
}

class _SelectedDeck extends StatelessWidget {
  const _SelectedDeck();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < 3; i++) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TopDashSpacing.xs),
            child: SelectedCard(i, key: ValueKey('SelectedCard$i')),
          ),
        ]
      ],
    );
  }
}

class SelectedCard extends StatelessWidget {
  const SelectedCard(this.index, {super.key});

  final int index;

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<DraftBloc>();
    final selectedCards = bloc.state.selectedCards;
    final card = index < selectedCards.length ? selectedCards[index] : null;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          bloc.add(SelectCard(index));
        },
        child: Container(
          height: 145,
          width: 103,
          decoration: card == null
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(TopDashSpacing.sm),
                  border: Border.all(color: TopDashColors.seedGrey90),
                )
              : null,
          child: Stack(
            children: [
              if (card != null) ...[
                GameCard(
                  image: card.image,
                  name: card.name,
                  description: card.description,
                  suitName: card.suit.name,
                  power: card.power,
                  isRare: card.rarity,
                  size: const GameCardSize.xs(),
                ),
              ],
              Positioned(
                bottom: TopDashSpacing.xs,
                right: TopDashSpacing.xs,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: TopDashColors.seedWhite,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      width: 2,
                      color: TopDashColors.seedBlack,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(-2, 2),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, size: 32),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.routerNeglectCall,
  });

  final RouterNeglectCall routerNeglectCall;

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<DraftBloc>();
    final state = bloc.state;
    final l10n = context.l10n;

    return IoFlipBottomBar(
      leading: const AudioToggleButton(),
      middle: state.status == DraftStateStatus.deckSelected
          ? RoundedButton.text(
              l10n.joinMatch.toUpperCase(),
              onPressed: () => routerNeglectCall(
                context,
                () => GoRouter.of(context).goNamed(
                  'match_making',
                  extra: MatchMakingPageData(
                    deck: state.selectedCards.cast<Card>(),
                  ),
                ),
              ),
              onLongPress: () => showPrivateMatchDialog(context),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.deckBuildingTitle,
                  style: TopDashTextStyles.mobileH6Light,
                ),
                const SizedBox(height: TopDashSpacing.xs),
                Text(
                  l10n.deckBuildingSubtitle,
                  style: TopDashTextStyles.bodySM,
                ),
              ],
            ),
      trailing: RoundedButton.icon(
        Icons.question_mark_rounded,
        onPressed: () => TopDashDialog.show(
          context,
          const HowToPlayDialog(),
        ),
      ),
    );
  }

  void showPrivateMatchDialog(BuildContext context) {
    final bloc = context.read<DraftBloc>();
    final state = bloc.state;
    final goRouter = GoRouter.of(context);

    showDialog<String?>(
      context: context,
      builder: (_) => _JoinPrivateMatchDialog(
        selectedCards: state.selectedCards.cast<Card>(),
        routerNeglectCall: routerNeglectCall,
      ),
    ).then((inviteCode) {
      if (inviteCode != null) {
        routerNeglectCall(
          context,
          () => goRouter.goNamed(
            'match_making',
            queryParams: {
              'inviteCode': inviteCode,
            },
            extra: MatchMakingPageData(deck: state.selectedCards.cast<Card>()),
          ),
        );
      }
      return inviteCode;
    });
  }
}

class _JoinPrivateMatchDialog extends StatefulWidget {
  const _JoinPrivateMatchDialog({
    required this.selectedCards,
    required this.routerNeglectCall,
  });

  final List<Card> selectedCards;
  final RouterNeglectCall routerNeglectCall;

  @override
  State<_JoinPrivateMatchDialog> createState() =>
      _JoinPrivateMatchDialogState();
}

class _JoinPrivateMatchDialogState extends State<_JoinPrivateMatchDialog> {
  String? inviteCode;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 400,
        height: 300,
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Invite code',
              ),
              onChanged: (value) {
                setState(() {
                  inviteCode = value;
                });
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(inviteCode);
              },
              child: const Text('Join'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              child: const Text('Cancel'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => widget.routerNeglectCall(
                context,
                () => GoRouter.of(context).goNamed(
                  'match_making',
                  queryParams: {
                    'createPrivateMatch': 'true',
                  },
                  extra: MatchMakingPageData(deck: widget.selectedCards),
                ),
              ),
              child: const Text('Create private match'),
            ),
          ],
        ),
      ),
    );
  }
}
