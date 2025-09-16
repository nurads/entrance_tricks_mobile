// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Video _$VideoFromJson(Map<String, dynamic> json) => Video(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  url: json['url'] as String,
  duration: json['duration'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  isLocked: json['is_locked'] as bool? ?? true,
  isWatched: json['is_watched'] as bool? ?? false,
  image: json['image'] as String?,
  description: json['description'] as String?,
  isDownloaded: json['isDownloaded'] as bool? ?? false,
);

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'url': instance.url,
  'duration': instance.duration,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'image': instance.image,
  'is_locked': instance.isLocked,
  'description': instance.description,
  'is_watched': instance.isWatched,
  'isDownloaded': instance.isDownloaded,
};
