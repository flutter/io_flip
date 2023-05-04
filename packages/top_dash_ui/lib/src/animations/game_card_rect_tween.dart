// ignore_for_file: overridden_fields

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:io_flip_ui/top_dash_ui.dart';

/// {@template game_card_rect}
/// A class that holds information about card dimensions and position.
/// {@endtemplate}
class GameCardRect extends Equatable {
  /// {@macro game_card_rect}
  const GameCardRect({required this.gameCardSize, required this.offset});

  /// The size of the card.
  final GameCardSize gameCardSize;

  /// The offset of the card.
  final Offset offset;

  /// The calculated rect of the card.
  Rect get rect => offset & gameCardSize.size;

  @override
  List<Object?> get props => [gameCardSize, offset];
}

/// Interpolates between two [GameCardRect]s.
class GameCardRectTween extends Tween<GameCardRect?> {
  /// Creates a [GameCardRectTween].
  ///
  /// The [begin] and [end] properties must not be null when interpolated, but
  /// they may be null when constructed if they are filled in later.
  GameCardRectTween({
    super.begin,
    super.end,
  });

  @override
  GameCardRect? lerp(double t) {
    final gameCardSize = GameCardSize.lerp(
      begin?.gameCardSize,
      end?.gameCardSize,
      t,
    );

    return GameCardRect(
      gameCardSize: gameCardSize!,
      offset: Offset.lerp(begin?.offset, end?.offset, t)!,
    );
  }
}
