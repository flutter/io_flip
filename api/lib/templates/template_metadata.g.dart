// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TemplateMetadata _$TemplateMetadataFromJson(Map<String, dynamic> json) =>
    TemplateMetadata(
      title: json['title'] as String,
      description: json['description'] as String,
      shareUrl: json['shareUrl'] as String,
      favIconUrl: json['favIconUrl'] as String,
      ga: json['ga'] as String,
      gameUrl: json['gameUrl'] as String,
      image: json['image'] as String,
    );

Map<String, dynamic> _$TemplateMetadataToJson(TemplateMetadata instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'shareUrl': instance.shareUrl,
      'favIconUrl': instance.favIconUrl,
      'ga': instance.ga,
      'gameUrl': instance.gameUrl,
      'image': instance.image,
    };
