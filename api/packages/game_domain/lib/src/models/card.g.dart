// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Card _$CardFromJson(Map<String, dynamic> json) => Card(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      power: json['power'] as int,
      rarity: json['rarity'] as bool,
      suit: $enumDecode(_$SuitEnumMap, json['suit']),
      shareImage: json['shareImage'] as String?,
    );

Map<String, dynamic> _$CardToJson(Card instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'power': instance.power,
      'rarity': instance.rarity,
      'suit': _$SuitEnumMap[instance.suit]!,
      'shareImage': instance.shareImage,
    };

const _$SuitEnumMap = {
  Suit.fire: 'fire',
  Suit.air: 'air',
  Suit.earth: 'earth',
  Suit.metal: 'metal',
  Suit.water: 'water',
};
