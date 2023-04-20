import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart' as game;
import 'package:go_router/go_router.dart';
import 'package:top_dash/game/game.dart';
import 'package:top_dash/game/views/game_summary.dart';
import 'package:top_dash/leaderboard/leaderboard.dart';
import 'package:top_dash_ui/top_dash_ui.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        late final Widget child;

        if (state is MatchLoadingState) {
          child = const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is MatchLoadFailedState) {
          child = const Center(
            child: Text('Unable to join game!'),
          );
        }

        if (state is MatchLoadedState) {
          if (state.matchState.result != null && state.turnAnimationsFinished) {
            return const GameSummaryView();
          }

          child = const _GameBoard();
        }

        if (state is LeaderboardEntryState) {
          child = LeaderboardEntryView(
            scoreCardId: state.scoreCardId,
          );
        }

        if (state is OpponentAbsentState) {
          child = Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Opponent left the game!'),
                ElevatedButton(
                  onPressed: () => GoRouter.of(context).pop(),
                  child: const Text('Replay'),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          body: child,
        );
      },
    );
  }
}

const clashCardSize = TopDashCardSizes.md;
const playerHandCardSize = TopDashCardSizes.sm;
const opponentHandCardSize = TopDashCardSizes.xs;
const counterSize = Size(56, 56);

const cardSpacingX = TopDashSpacing.sm;
const cardSpacingY = TopDashSpacing.xlg;
const cardsAtHand = 3;

const movingCardDuration = Duration(milliseconds: 400);
const turnEndDuration = Duration(milliseconds: 250);

class _GameBoard extends StatefulWidget {
  const _GameBoard();

  @override
  State<_GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<_GameBoard> with TickerProviderStateMixin {
  final boardSize = Size(
    2 * clashCardSize.width + cardSpacingX,
    opponentHandCardSize.height +
        cardSpacingY +
        clashCardSize.height +
        cardSpacingY +
        playerHandCardSize.height,
  );

  // Opponent card position calculations
  late final opponentLeftPadding = (boardSize.width -
          cardsAtHand * (opponentHandCardSize.width + cardSpacingX)) /
      2;

  late final opponentCardOffsets = List.generate(
    cardsAtHand,
    (index) => Offset(
      index * (opponentHandCardSize.width + cardSpacingX) + opponentLeftPadding,
      0,
    ),
  );

  // Clash zone card position calculations
  final clashCardPositionY = opponentHandCardSize.height + cardSpacingY;

  late final clashCardOffsets = [
    Offset(0, clashCardPositionY),
    Offset(clashCardSize.width + cardSpacingX, clashCardPositionY),
  ];

  // Player card position calculations
  late final playerLeftPadding = (boardSize.width -
          cardsAtHand * (playerHandCardSize.width + cardSpacingX)) /
      2;

  final playerCardPositionY = opponentHandCardSize.height +
      cardSpacingY +
      clashCardSize.height +
      cardSpacingY;

  late final playerCardOffsets = List.generate(
    cardsAtHand,
    (index) => Offset(
      index * (playerHandCardSize.width + cardSpacingX) + playerLeftPadding,
      playerCardPositionY,
    ),
  );

  //Counter position
  late final counterY = opponentHandCardSize.height +
      cardSpacingY +
      (clashCardSize.height - counterSize.height) / 2;

  late final counterX =
      (2 * clashCardSize.width + cardSpacingX - counterSize.width) / 2;

  late final counterOffset = Offset(counterX, counterY);

  List<AnimationController> clashControllers = [];

  // Opponent animation controllers
  late final opponentCardControllers = createAnimationControllers();

  late final opponentCardAnimations = createAnimations(
    controllers: opponentCardControllers,
    begin: (i) => opponentCardOffsets[i] & opponentHandCardSize,
    end: clashCardOffsets.last & clashCardSize,
  );

  // Player animation controllers
  late final playerCardControllers = createAnimationControllers();

  late final playerCardAnimations = createAnimations(
    controllers: playerCardControllers,
    begin: (i) => playerCardOffsets[i] & playerHandCardSize,
    end: clashCardOffsets.first & clashCardSize,
  );

  late final playerAnimatedCardControllers = createAnimatedCardControllers(
    controllers: playerCardControllers,
  );

  List<AnimatedCardController> createAnimatedCardControllers({
    required List<AnimationController> controllers,
  }) {
    return controllers.map((e) {
      final cardController = AnimatedCardController();
      e.addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          cardController.run(bigFlipAnimation);
        }
      });

      return cardController;
    }).toList();
  }

  List<Animation<Rect?>> createAnimations({
    required List<AnimationController> controllers,
    required Rect Function(int) begin,
    required Rect end,
  }) {
    return controllers
        .mapIndexed(
          (i, e) => RectTween(begin: begin(i), end: end).animate(e)
            ..addStatusListener(turnCompleted)
            ..addStatusListener(turnAnimationsCompleted),
        )
        .toList();
  }

  List<AnimationController> createAnimationControllers() {
    return List.generate(
      cardsAtHand,
      (index) => AnimationController(duration: movingCardDuration, vsync: this),
    );
  }

  void turnCompleted(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      final bloc = context.read<GameBloc>();
      final state = bloc.state as MatchLoadedState;
      if (state.rounds.isNotEmpty) {
        if (state.rounds.last.isComplete()) {
          bloc.add(const CardOverlayRevealed());
          for (final controller in clashControllers) {
            Future.delayed(turnEndDuration, controller.reverse);
            clashControllers = [];
          }
        }
      }
    }
  }

  void turnAnimationsCompleted(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      context.read<GameBloc>().add(const TurnAnimationsFinished());
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<GameBloc>();

    return BlocListener<GameBloc, GameState>(
      listenWhen: (previous, current) {
        if (previous is MatchLoadedState && current is MatchLoadedState) {
          return previous.rounds != current.rounds;
        }
        return false;
      },
      listener: (context, state) {
        if (state is MatchLoadedState) {
          final lastPlayedCardId = state.lastPlayedCardId;
          final playerIndex = bloc.playerCards
              .indexWhere((element) => element.id == lastPlayedCardId);
          if (playerIndex >= 0) {
            final controller = playerCardControllers[playerIndex]..forward();
            clashControllers.add(controller);
          }
          final opponentIndex = bloc.opponentCards
              .indexWhere((element) => element.id == lastPlayedCardId);
          if (opponentIndex >= 0) {
            final controller = opponentCardControllers[opponentIndex]
              ..forward();
            clashControllers.add(controller);
          }
        }
      },
      child: Center(
        child: SizedBox(
          width: boardSize.width,
          height: boardSize.height,
          child: Stack(
            children: [
              ...clashCardOffsets.mapIndexed(
                (i, offset) {
                  return _ClashCard(
                    rect: offset & clashCardSize,
                  );
                },
              ),
              ...bloc.opponentCards.mapIndexed(
                (i, card) {
                  return _OpponentCard(
                    card: card,
                    animation: opponentCardAnimations[i],
                  );
                },
              ),
              ...bloc.playerCards.mapIndexed(
                (i, card) {
                  return _PlayerCard(
                    card: card,
                    animation: playerCardAnimations[i],
                    animatedCardController: playerAnimatedCardControllers[i],
                  );
                },
              ),
              _BoardCounter(counterOffset),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    final controllers = [
      ...playerCardControllers,
      ...opponentCardControllers,
    ];
    for (final element in controllers) {
      element.dispose();
    }

    for (final element in playerAnimatedCardControllers) {
      element.dispose();
    }

    super.dispose();
  }
}

class _OpponentCard extends StatelessWidget {
  const _OpponentCard({
    required this.card,
    required this.animation,
  });

  final game.Card card;
  final Animation<Rect?> animation;

  @override
  Widget build(BuildContext context) {
    final rounds = context.select<GameBloc, List<MatchRound>>(
      (bloc) => (bloc.state as MatchLoadedState).rounds,
    );
    final overlay = context.select<GameBloc, CardOverlayType?>(
      (bloc) => bloc.isWinningCard(card, isPlayer: false),
    );

    final allOpponentPlayedCards =
        rounds.map((turn) => turn.opponentCardId).toList();

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final rect = animation.value!;
        return Positioned.fromRect(
          key: Key('opponent_card_${card.id}'),
          rect: rect,
          child:
              allOpponentPlayedCards.contains(card.id) && animation.isDismissed
                  ? Stack(
                      children: [
                        GameCard(
                          key: Key('opponent_revealed_card_${card.id}'),
                          image: card.image,
                          name: card.name,
                          power: card.power,
                          suitName: card.suit.name,
                          isRare: card.rarity,
                          width: rect.width,
                          height: rect.height,
                          overlay: overlay,
                        ),
                      ],
                    )
                  : FlippedGameCard(
                      key: Key('opponent_hidden_card_${card.id}'),
                      width: TopDashCardSizes.xs.width,
                      height: TopDashCardSizes.xs.height,
                    ),
        );
      },
    );
  }
}

class _PlayerCard extends StatelessWidget {
  const _PlayerCard({
    required this.card,
    required this.animation,
    required this.animatedCardController,
  });

  final game.Card card;
  final Animation<Rect?> animation;
  final AnimatedCardController animatedCardController;

  @override
  Widget build(BuildContext context) {
    final rounds = context.select<GameBloc, List<MatchRound>>(
      (bloc) => (bloc.state as MatchLoadedState).rounds,
    );
    final overlay = context.select<GameBloc, CardOverlayType?>(
      (bloc) => bloc.isWinningCard(card, isPlayer: true),
    );

    final allPlayerPlayedCards =
        rounds.map((turn) => turn.playerCardId).toList();

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final rect = animation.value!;
        return Positioned.fromRect(
          rect: rect,
          child: InkWell(
            key: Key('player_card_${card.id}'),
            onTap: () {
              final bloc = context.read<GameBloc>();
              final state = bloc.state as MatchLoadedState;
              if (!allPlayerPlayedCards.contains(card.id) &&
                  bloc.canPlayerPlay(card.id) &&
                  state.turnAnimationsFinished) {
                context.read<GameBloc>().add(PlayerPlayed(card.id));
              }
            },
            child: AnimatedCard(
              controller: animatedCardController,
              front: GameCard(
                image: card.image,
                name: card.name,
                power: card.power,
                suitName: card.suit.name,
                isRare: card.rarity,
                width: rect.width,
                height: rect.height,
                overlay: overlay,
              ),
              back: FlippedGameCard(
                width: TopDashCardSizes.xs.width,
                height: TopDashCardSizes.xs.height,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ClashCard extends StatelessWidget {
  const _ClashCard({
    required this.rect,
  });

  final Rect rect;

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: rect,
      child: Container(
        height: clashCardSize.height,
        width: clashCardSize.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: TopDashColors.seedPaletteLightBlue99,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: TopDashColors.seedPaletteLightBlue80,
          ),
        ),
      ),
    );
  }
}

class _BoardCounter extends StatelessWidget {
  const _BoardCounter(this.counterOffset);

  final Offset counterOffset;

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<GameBloc>();
    final state = bloc.state as MatchLoadedState;

    return Positioned(
      left: counterOffset.dx,
      top: counterOffset.dy,
      child: Offstage(
        offstage: !bloc.isPlayerAllowedToPlay,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: TopDashColors.seedWhite.withOpacity(.25),
              width: 8,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            width: counterSize.width,
            height: counterSize.height,
            decoration: BoxDecoration(
              color: TopDashColors.seedWhite,
              shape: BoxShape.circle,
              border: Border.all(color: TopDashColors.seedBlue, width: 2),
            ),
            child: Text(
              '${state.turnTimeRemaining}',
              style: TopDashTextStyles.cardNumberLG
                  .copyWith(color: TopDashColors.seedBlue),
            ),
          ),
        ),
      ),
    );
  }
}
