// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Match _$MatchFromJson(Map<String, dynamic> json) => Match(
      id: json['id'] as String,
      hostDeck: Deck.fromJson(json['hostDeck'] as Map<String, dynamic>),
      guestDeck: Deck.fromJson(json['guestDeck'] as Map<String, dynamic>),
      hostConnected: json['hostConnected'] as bool? ?? false,
      guestConnected: json['guestConnected'] as bool? ?? false,
    );

Map<String, dynamic> _$MatchToJson(Match instance) => <String, dynamic>{
      'id': instance.id,
      'hostDeck': instance.hostDeck.toJson(),
      'guestDeck': instance.guestDeck.toJson(),
      'hostConnected': instance.hostConnected,
      'guestConnected': instance.guestConnected,
    };
