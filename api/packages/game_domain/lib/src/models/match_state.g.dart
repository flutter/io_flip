// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchState _$MatchStateFromJson(Map<String, dynamic> json) => MatchState(
      id: json['id'] as String,
      matchId: json['matchId'] as String,
      hostPlayedCards: (json['hostPlayedCards'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      guestPlayedCards: (json['guestPlayedCards'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MatchStateToJson(MatchState instance) =>
    <String, dynamic>{
      'id': instance.id,
      'matchId': instance.matchId,
      'hostPlayedCards': instance.hostPlayedCards,
      'guestPlayedCards': instance.guestPlayedCards,
    };
