// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_description.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardDescription _$CardDescriptionFromJson(Map<String, dynamic> json) =>
    CardDescription(
      character: json['character'] as String,
      characterClass: json['characterClass'] as String,
      power: json['power'] as String,
      powerShortened: json['powerShortened'] as String,
      location: json['location'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$CardDescriptionToJson(CardDescription instance) =>
    <String, dynamic>{
      'character': instance.character,
      'characterClass': instance.characterClass,
      'power': instance.power,
      'powerShortened': instance.powerShortened,
      'location': instance.location,
      'description': instance.description,
    };
