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
      product: json['product'] as int,
      design: json['design'] as int,
      frontend: json['frontend'] as int,
      backend: json['backend'] as int,
      rarity: json['rarity'] as bool,
    );

Map<String, dynamic> _$CardToJson(Card instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'product': instance.product,
      'design': instance.design,
      'frontend': instance.frontend,
      'backend': instance.backend,
      'rarity': instance.rarity,
    };
