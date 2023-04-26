import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart' as game;
import 'package:game_domain/game_domain.dart';
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
        final Widget child;

        if (state is MatchLoadingState) {
          child = const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MatchLoadFailedState) {
          child = const Center(
            child: Text('Unable to join game!'),
          );
        } else if (state is MatchLoadedState) {
          if (state.matchState.result != null && state.turnAnimationsFinished) {
            return const GameSummaryView();
          }
          child = const _GameBoard();
        } else if (state is LeaderboardEntryState) {
          child = LeaderboardEntryView(
            scoreCardId: state.scoreCardId,
            shareHandPageData: state.shareHandPageData,
          );
        } else if (state is OpponentAbsentState) {
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
        } else {
          child = const SizedBox();
        }

        return IoFlipScaffold(
          body: child,
        );
      },
    );
  }
}

const clashCardSize = GameCardSize.md();
const playerHandCardSize = GameCardSize.sm();
const opponentHandCardSize = GameCardSize.xs();
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
    begin: (i) => GameCardRect(
      offset: opponentCardOffsets[i],
      gameCardSize: opponentHandCardSize,
    ),
    end: GameCardRect(
      offset: clashCardOffsets.first,
      gameCardSize: clashCardSize,
    ),
  );

  // Player animation controllers
  late final playerCardControllers = createAnimationControllers();

  late final playerCardAnimations = createAnimations(
    controllers: playerCardControllers,
    begin: (i) => GameCardRect(
      offset: playerCardOffsets[i],
      gameCardSize: playerHandCardSize,
    ),
    end: GameCardRect(
      offset: clashCardOffsets.last,
      gameCardSize: clashCardSize,
    ),
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
        if (status == AnimationStatus.completed) {
          cardController.run(bigFlipAnimation);
          Future.delayed(
            bigFlipAnimation.duration * .85,
            () => context.read<GameBloc>().add(const CardLandingStarted()),
          );
        }
        if (status == AnimationStatus.dismissed) {
          cardController.run(bigFlipAnimation);
        }
      });

      return cardController;
    }).toList();
  }

  List<Animation<GameCardRect?>> createAnimations({
    required List<AnimationController> controllers,
    required GameCardRect Function(int) begin,
    required GameCardRect end,
  }) {
    return controllers
        .mapIndexed(
          (i, e) => GameCardRectTween(begin: begin(i), end: end).animate(e)
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
      if (bloc.state is MatchLoadedState) {
        final state = bloc.state as MatchLoadedState;
        if (state.rounds.isNotEmpty) {
          if (state.rounds.last.isComplete()) {
            Future.delayed(
              bigFlipAnimation.duration + CardLandingPuff.duration,
              () => bloc.add(const ClashSceneStarted()),
            );
          }
        }
      }
    }
  }

  void turnAnimationsCompleted(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      context.read<GameBloc>()
        ..add(const TurnAnimationsFinished())
        ..add(const TurnTimerStarted());
    }
  }

  void fightSceneCompleted() {
    context.read<GameBloc>().add(const FightSceneCompleted());
    for (final controller in clashControllers) {
      Future.delayed(turnEndDuration, controller.reverse);
      clashControllers = [];
    }
  }

  int? lastPlayedPlayerCardIndex;
  int? lastPlayedOpponentCardIndex;

  @override
  Widget build(BuildContext context) {
    final playerCards =
        context.select<GameBloc, List<Card>>((bloc) => bloc.playerCards);
    final opponentCards =
        context.select<GameBloc, List<Card>>((bloc) => bloc.opponentCards);

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
          final playerIndex = playerCards
              .indexWhere((element) => element.id == lastPlayedCardId);
          if (playerIndex >= 0) {
            lastPlayedPlayerCardIndex = playerIndex;
            final controller = playerCardControllers[playerIndex]..forward();
            clashControllers.add(controller);
          }
          final opponentIndex = opponentCards
              .indexWhere((element) => element.id == lastPlayedCardId);
          if (opponentIndex >= 0) {
            lastPlayedOpponentCardIndex = opponentIndex;
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
            clipBehavior: Clip.none,
            children: [
              for (final offset in playerCardOffsets)
                _PlaceholderCard(
                  rect: offset & playerHandCardSize.size,
                ),
              for (final offset in opponentCardOffsets)
                _PlaceholderCard(
                  rect: offset & opponentHandCardSize.size,
                ),
              ...clashCardOffsets.mapIndexed(
                (i, offset) {
                  return _ClashCard(
                    rect: offset & clashCardSize.size,
                    showPlus: i == 1,
                  );
                },
              ),
              ...opponentCards.mapIndexed(
                (i, card) {
                  return _OpponentCard(
                    card: card,
                    animation: opponentCardAnimations[i],
                  );
                },
              ),
              const _CardLandingPuffEffect(),
              ...playerCards.mapIndexed(
                (i, card) {
                  return _PlayerCard(
                    card: card,
                    animation: playerCardAnimations[i],
                    animatedCardController: playerAnimatedCardControllers[i],
                  );
                },
              ),
              _BoardCounter(counterOffset),
              _ClashScene(
                onFinished: fightSceneCompleted,
                opponentCard: () => opponentCards.elementAt(
                  lastPlayedOpponentCardIndex!,
                ),
                playerCard: () => playerCards.elementAt(
                  lastPlayedPlayerCardIndex!,
                ),
              ),
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

class _PlaceholderCard extends StatelessWidget {
  const _PlaceholderCard({required this.rect});

  final Rect rect;

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: rect,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: TopDashColors.seedWhite.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: TopDashColors.seedPaletteNeutral95,
          ),
        ),
        child: Opacity(
          opacity: 0.6,
          child: IoFlipLogo.white(
            width: rect.width - 20,
          ),
        ),
      ),
    );
  }
}

class _OpponentCard extends StatelessWidget {
  const _OpponentCard({
    required this.card,
    required this.animation,
  });

  final game.Card card;
  final Animation<GameCardRect?> animation;

  @override
  Widget build(BuildContext context) {
    final overlay = context.select<GameBloc, CardOverlayType?>(
      (bloc) => bloc.isWinningCard(card, isPlayer: false),
    );

    final alreadyPlayed = context.select<GameBloc, bool>((bloc) {
      if (bloc.state is MatchLoadedState) {
        final state = bloc.state as MatchLoadedState;
        return state.rounds.any((element) => element.opponentCardId == card.id);
      }
      return false;
    });

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final position = animation.value!;
        return Positioned.fromRect(
          key: Key('opponent_card_${card.id}'),
          rect: position.rect,
          child: alreadyPlayed && animation.isDismissed
              ? Stack(
                  children: [
                    GameCard(
                      key: Key('opponent_revealed_card_${card.id}'),
                      image: card.image,
                      name: card.name,
                      description: card.description,
                      power: card.power,
                      suitName: card.suit.name,
                      isRare: card.rarity,
                      size: position.gameCardSize,
                      overlay: overlay,
                    ),
                  ],
                )
              : FlippedGameCard(
                  key: Key('opponent_hidden_card_${card.id}'),
                  size: const GameCardSize.xs(),
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
  final Animation<GameCardRect?> animation;
  final AnimatedCardController animatedCardController;

  @override
  Widget build(BuildContext context) {
    final overlay = context.select<GameBloc, CardOverlayType?>(
      (bloc) => bloc.isWinningCard(card, isPlayer: true),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final position = animation.value!;
        return Positioned.fromRect(
          rect: position.rect,
          child: InkWell(
            key: Key('player_card_${card.id}'),
            onTap: () {
              final bloc = context.read<GameBloc>();
              if (bloc.state is MatchLoadedState) {
                final state = bloc.state as MatchLoadedState;
                if (bloc.canPlayerPlay(card.id) &&
                    state.turnAnimationsFinished) {
                  context.read<GameBloc>().add(PlayerPlayed(card.id));
                }
              }
            },
            child: AnimatedCard(
              controller: animatedCardController,
              front: GameCard(
                image: card.image,
                name: card.name,
                description: card.description,
                power: card.power,
                suitName: card.suit.name,
                isRare: card.rarity,
                size: position.gameCardSize,
                overlay: overlay,
              ),
              back: const FlippedGameCard(
                size: GameCardSize.xs(),
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
    required this.showPlus,
  });

  final Rect rect;
  final bool showPlus;

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: rect,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: TopDashColors.seedWhite.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: TopDashColors.seedPaletteNeutral95,
          ),
        ),
        child: showPlus
            ? const SizedBox.square(
                dimension: 57,
                child: CustomPaint(painter: CrossPainter()),
              )
            : const SizedBox(),
      ),
    );
  }
}

@visibleForTesting
class CrossPainter extends CustomPainter {
  const CrossPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = TopDashColors.seedWhite
      ..style = PaintingStyle.stroke;

    canvas
      ..drawLine(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        paint,
      )
      ..drawLine(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        paint,
      );
  }

  @override
  bool shouldRepaint(covariant CrossPainter oldDelegate) => false;
}

class _BoardCounter extends StatelessWidget {
  const _BoardCounter(this.counterOffset);

  final Offset counterOffset;

  @override
  Widget build(BuildContext context) {
    final turnTimeRemaining = context.select(
      (GameBloc bloc) => bloc.state is MatchLoadedState
          ? (bloc.state as MatchLoadedState).turnTimeRemaining
          : 0,
    );

    return Positioned(
      left: counterOffset.dx,
      top: counterOffset.dy,
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
            border: Border.all(color: TopDashColors.seedBlack, width: 2),
          ),
          child: Text(
            '$turnTimeRemaining',
            style: TopDashTextStyles.cardNumberLG
                .copyWith(color: TopDashColors.seedBlack),
          ),
        ),
      ),
    );
  }
}

class _CardLandingPuffEffect extends StatelessWidget {
  const _CardLandingPuffEffect();

  @override
  Widget build(BuildContext context) {
    final showCardLanding = context.select<GameBloc, bool>(
      (bloc) => (bloc.state as MatchLoadedState).showCardLanding,
    );
    if (showCardLanding) {
      return Positioned(
        top: -20,
        right: -160,
        child: CardLandingPuff(
          playing: showCardLanding,
          onComplete: () {
            context.read<GameBloc>().add(const CardLandingCompleted());
          },
        ),
      );
    }
    return const SizedBox();
  }
}

class _ClashScene extends StatelessWidget {
  const _ClashScene({
    required this.onFinished,
    required this.opponentCard,
    required this.playerCard,
  });

  final VoidCallback onFinished;
  final Card Function() opponentCard;
  final Card Function() playerCard;

  @override
  Widget build(BuildContext context) {
    final isClashScene = context.select<GameBloc, bool>(
      (bloc) => (bloc.state as MatchLoadedState).isFightScene,
    );

    if (isClashScene) {
      return Positioned.fill(
        child: FightScene(
          onFinished: onFinished,
          opponentCard: opponentCard(),
          playerCard: playerCard(),
        ),
      );
    }
    return const SizedBox();
  }
}
