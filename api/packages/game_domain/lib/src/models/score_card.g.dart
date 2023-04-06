// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScoreCard _$ScoreCardFromJson(Map<String, dynamic> json) => ScoreCard(
      id: json['id'] as String,
      wins: json['wins'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      currentDeck: json['currentDeck'] as String? ?? '',
      longestStreakDeck: json['longestStreakDeck'] as String? ?? '',
      initials: json['initials'] as String?,
    );
