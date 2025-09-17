// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Video _$VideoFromJson(Map<String, dynamic> json) => Video(
  id: (json['id'] as num).toInt(),
  chapter: (json['chapter'] as num).toInt(),
  title: json['title'] as String,
  file: json['file'] as String,
  duration: (json['duration_in_minutes'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  isLocked: json['is_locked'] as bool? ?? true,
  isWatched: json['is_watched'] as bool? ?? false,
  image: json['image'] as String?,
  description: json['description'] as String?,
  thumbnail: json['thumbnail'] as String?,
  isDownloaded: json['is_downloaded'] as bool? ?? false,
);

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
  'id': instance.id,
  'chapter': instance.chapter,
  'title': instance.title,
  'file': instance.file,
  'duration_in_minutes': instance.duration,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'image': instance.image,
  'is_locked': instance.isLocked,
  'description': instance.description,
  'is_watched': instance.isWatched,
  'is_downloaded': instance.isDownloaded,
  'thumbnail': instance.thumbnail,
};
