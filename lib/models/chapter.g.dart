// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chapter _$ChapterFromJson(Map<String, dynamic> json) => Chapter(
  id: (json['id'] as num).toInt(),
  chapterNumber: (json['chapterNumber'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String?,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
  isLocked: json['isLocked'] as bool? ?? false,
  notes: json['notes'] as List<dynamic>? ?? const [],
  quizzes: json['quizzes'] as List<dynamic>? ?? const [],
  videos: json['videos'] as List<dynamic>? ?? const [],
);

Map<String, dynamic> _$ChapterToJson(Chapter instance) => <String, dynamic>{
  'id': instance.id,
  'chapterNumber': instance.chapterNumber,
  'title': instance.title,
  'description': instance.description,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
  'isLocked': instance.isLocked,
  'notes': instance.notes,
  'quizzes': instance.quizzes,
  'videos': instance.videos,
};
