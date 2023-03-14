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
    );

Map<String, dynamic> _$ScoreCardToJson(ScoreCard instance) => <String, dynamic>{
      'id': instance.id,
      'wins': instance.wins,
      'longestStreak': instance.longestStreak,
      'currentStreak': instance.currentStreak,
    };
