// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompt_term.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromptTerm _$PromptTermFromJson(Map<String, dynamic> json) => PromptTerm(
      term: json['term'] as String,
      type: $enumDecode(_$PromptTermTypeEnumMap, json['type']),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$PromptTermToJson(PromptTerm instance) =>
    <String, dynamic>{
      'id': instance.id,
      'term': instance.term,
      'type': _$PromptTermTypeEnumMap[instance.type]!,
    };

const _$PromptTermTypeEnumMap = {
  PromptTermType.character: 'character',
  PromptTermType.characterClass: 'characterClass',
  PromptTermType.power: 'power',
  PromptTermType.secondaryPower: 'secondaryPower',
  PromptTermType.location: 'location',
};
