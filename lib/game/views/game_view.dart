import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart' as game;
import 'package:go_router/go_router.dart';
import 'package:top_dash/game/game.dart';
import 'package:top_dash/game/views/game_summary.dart';
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
          if (state.matchState.result != null) {
            return const GameSummaryView();
          }
          child = const _GameBoard();
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
          backgroundColor: TopDashColors.seedWhite,
          body: child,
        );
      },
    );
  }
}

const fightCardSize = TopDashCardSizes.md;
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
    2 * fightCardSize.width + cardSpacingX,
    opponentHandCardSize.height +
        cardSpacingY +
        fightCardSize.height +
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

  // Fight zone card position calculations
  final fightCardPositionY = opponentHandCardSize.height + cardSpacingY;

  late final fightCardOffsets = List.generate(
    2,
    (index) => Offset(
      index * (fightCardSize.width + cardSpacingX),
      fightCardPositionY,
    ),
  );

  // Player card position calculations
  late final playerLeftPadding = (boardSize.width -
          cardsAtHand * (playerHandCardSize.width + cardSpacingX)) /
      2;

  final playerCardPositionY = opponentHandCardSize.height +
      cardSpacingY +
      fightCardSize.height +
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
      (fightCardSize.height - counterSize.height) / 2;

  late final counterX =
      (2 * fightCardSize.width + cardSpacingX - counterSize.width) / 2;

  late final counterOffset = Offset(counterX, counterY);

  List<AnimationController> fightControllers = [];

  // Opponent animation controllers
  late final opponentCardControllers = createAnimationControllers();

  late final opponentCardAnimations = createAnimations(
    controllers: opponentCardControllers,
    begin: (i) => opponentCardOffsets[i] & opponentHandCardSize,
    end: fightCardOffsets.last & fightCardSize,
  );

  // Player animation controllers
  late final playerCardControllers = createAnimationControllers();

  late final playerCardAnimations = createAnimations(
    controllers: playerCardControllers,
    begin: (i) => playerCardOffsets[i] & playerHandCardSize,
    end: fightCardOffsets.first & fightCardSize,
  );

  List<Animation<Rect?>> createAnimations({
    required List<AnimationController> controllers,
    required Rect Function(int) begin,
    required Rect end,
  }) {
    return controllers
        .mapIndexed(
          (i, e) => RectTween(begin: begin(i), end: end).animate(e)
            ..addStatusListener(moveCardsToHandOnTurnCompleted)
            ..addListener(() => setState(() {})),
        )
        .toList();
  }

  List<AnimationController> createAnimationControllers() {
    return List.generate(
      cardsAtHand,
      (index) => AnimationController(duration: movingCardDuration, vsync: this),
    );
  }

  void moveCardsToHandOnTurnCompleted(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      final state = context.read<GameBloc>().state as MatchLoadedState;
      if (state.turns.isNotEmpty) {
        if (state.turns.last.isComplete()) {
          for (final controller in fightControllers) {
            Future.delayed(turnEndDuration, controller.reverse);
            fightControllers = [];
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<GameBloc>();

    return BlocListener<GameBloc, GameState>(
      listenWhen: (previous, current) {
        if (previous is MatchLoadedState && current is MatchLoadedState) {
          return previous.turns != current.turns;
        }
        return false;
      },
      listener: (context, state) {
        if (state is MatchLoadedState) {
          final lastPlayedCardId = bloc.lastPlayedCardId;
          final playerIndex = bloc.playerCards
              .indexWhere((element) => element.id == lastPlayedCardId);
          if (playerIndex >= 0) {
            final controller = playerCardControllers[playerIndex]..forward();
            fightControllers.add(controller);
          }
          final opponentIndex = bloc.opponentCards
              .indexWhere((element) => element.id == lastPlayedCardId);
          if (opponentIndex >= 0) {
            final controller = opponentCardControllers[opponentIndex]
              ..forward();
            fightControllers.add(controller);
          }
        }
      },
      child: Center(
        child: SizedBox(
          width: boardSize.width,
          height: boardSize.height,
          child: Stack(
            children: [
              ...fightCardOffsets.mapIndexed(
                (i, offset) {
                  final isSlotTurn = (bloc.isPlayerTurn && i.isEven) ||
                      (!bloc.isPlayerTurn && i.isOdd);
                  return _FightCard(
                    rect: offset & fightCardSize,
                    isSlotTurn: isSlotTurn,
                    isPlayerTurn: bloc.isPlayerTurn,
                  );
                },
              ),
              ...bloc.opponentCards.mapIndexed(
                (i, card) {
                  return _OpponentCard(
                    card: card,
                    rect: opponentCardAnimations[i].value!,
                  );
                },
              ),
              ...bloc.playerCards.mapIndexed(
                (i, card) {
                  return _PlayerCard(
                    card: card,
                    rect: playerCardAnimations[i].value!,
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
    for (final element in playerCardControllers) {
      element.dispose();
    }
    for (final element in opponentCardControllers) {
      element.dispose();
    }

    super.dispose();
  }
}

class _OpponentCard extends StatelessWidget {
  const _OpponentCard({
    required this.card,
    required this.rect,
  });

  final game.Card card;
  final Rect rect;

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<GameBloc>();
    final state = bloc.state as MatchLoadedState;

    final allOpponentPlayedCards =
        state.turns.map((turn) => turn.opponentCardId).toList();

    return Positioned.fromRect(
      rect: rect,
      child: allOpponentPlayedCards.contains(card.id)
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
                  overlay: bloc.isWinningCard(card, isPlayer: false),
                ),
              ],
            )
          : FlippedGameCard(
              key: Key('opponent_hidden_card_${card.id}'),
              width: TopDashCardSizes.xs.width,
              height: TopDashCardSizes.xs.height,
            ),
    );
  }
}

class _PlayerCard extends StatelessWidget {
  const _PlayerCard({
    required this.card,
    required this.rect,
  });

  final game.Card card;
  final Rect rect;

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<GameBloc>();
    final state = bloc.state as MatchLoadedState;

    final allPlayerPlayedCards =
        state.turns.map((turn) => turn.playerCardId).toList();

    return Positioned.fromRect(
      rect: rect,
      child: InkWell(
        onTap: () {
          if (!allPlayerPlayedCards.contains(card.id) &&
              bloc.canPlayerPlay(card.id) &&
              !state.playerPlayed) {
            context.read<GameBloc>().add(PlayerPlayed(card.id));
          }
        },
        child: GameCard(
          key: Key('player_card_${card.id}'),
          image: card.image,
          name: card.name,
          power: card.power,
          suitName: card.suit.name,
          isRare: card.rarity,
          width: rect.width,
          height: rect.height,
          overlay: bloc.isWinningCard(card, isPlayer: true),
        ),
      ),
    );
  }
}

class _FightCard extends StatelessWidget {
  const _FightCard({
    required this.rect,
    required this.isSlotTurn,
    required this.isPlayerTurn,
  });

  final Rect rect;
  final bool isSlotTurn;
  final bool isPlayerTurn;

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: rect,
      child: Container(
        height: fightCardSize.height,
        width: fightCardSize.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSlotTurn
              ? TopDashColors.seedPaletteLightBlue99
              : TopDashColors.seedWhite,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSlotTurn
                ? TopDashColors.seedPaletteLightBlue80
                : TopDashColors.seedPaletteNeutral95,
          ),
        ),
        child: isSlotTurn
            ? Text(
                isPlayerTurn ? 'Your turn' : 'Their turn',
                style: TopDashTextStyles.headlineMobileH6Light,
              )
            : null,
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
        offstage: !bloc.isPlayerTurn,
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
