// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  content: json['content'] as String,
  chapter: (json['chapter'] as num).toInt(),
  isDownloaded: json['is_downloaded'] as bool,
  size: (json['size'] as num?)?.toInt(),
);

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'content': instance.content,
  'chapter': instance.chapter,
  'is_downloaded': instance.isDownloaded,
  'size': instance.size,
};
