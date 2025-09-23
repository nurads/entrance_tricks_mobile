// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
  id: (json['id'] as num).toInt(),
  content: json['content'] as String,
  image: json['image'] as String?,
  choices: (json['choices'] as List<dynamic>)
      .map((e) => Choice.fromJson(e as Map<String, dynamic>))
      .toList(),
  imagePath: json['image_path'] as String?,
);

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
  'id': instance.id,
  'content': instance.content,
  'image': instance.image,
  'choices': instance.choices,
  'image_path': instance.imagePath,
};

Choice _$ChoiceFromJson(Map<String, dynamic> json) => Choice(
  id: (json['id'] as num).toInt(),
  content: json['content'] as String,
  isCorrect: json['is_correct'] as bool,
);

Map<String, dynamic> _$ChoiceToJson(Choice instance) => <String, dynamic>{
  'id': instance.id,
  'content': instance.content,
  'is_correct': instance.isCorrect,
};
