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
      latestStreak: json['latestStreak'] as int? ?? 0,
      longestStreakDeck: json['longestStreakDeck'] as String? ?? '',
      currentDeck: json['currentDeck'] as String? ?? '',
      latestDeck: json['latestDeck'] as String? ?? '',
      initials: json['initials'] as String?,
    );

Map<String, dynamic> _$ScoreCardToJson(ScoreCard instance) => <String, dynamic>{
      'id': instance.id,
      'wins': instance.wins,
      'longestStreak': instance.longestStreak,
      'currentStreak': instance.currentStreak,
      'latestStreak': instance.latestStreak,
      'longestStreakDeck': instance.longestStreakDeck,
      'currentDeck': instance.currentDeck,
      'latestDeck': instance.latestDeck,
      'initials': instance.initials,
    };
