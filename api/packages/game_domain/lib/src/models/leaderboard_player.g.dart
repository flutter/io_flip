// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaderboardPlayer _$LeaderboardPlayerFromJson(Map<String, dynamic> json) =>
    LeaderboardPlayer(
      id: json['id'] as String,
      longestStreak: json['longestStreak'] as int,
      initials: json['initials'] as String,
    );

Map<String, dynamic> _$LeaderboardPlayerToJson(LeaderboardPlayer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'longestStreak': instance.longestStreak,
      'initials': instance.initials,
    };
