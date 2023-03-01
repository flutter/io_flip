// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Deck _$DeckFromJson(Map<String, dynamic> json) => Deck(
      id: json['id'] as String,
      cards: (json['cards'] as List<dynamic>)
          .map((e) => Card.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DeckToJson(Deck instance) => <String, dynamic>{
      'id': instance.id,
      'cards': instance.cards,
    };
