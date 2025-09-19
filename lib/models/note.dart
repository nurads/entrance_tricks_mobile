import 'package:json_annotation/json_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  final int id;
  final String title;
  final String content;
  final int chapter;
  @JsonKey(name: 'is_downloaded')
  final bool isDownloaded;

  final int? size;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.chapter,
    required this.isDownloaded,
    required this.size,
  });

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
  Map<String, dynamic> toJson() => _$NoteToJson(this);
}

class NoteTypeAdapter implements TypeAdapter<Note> {
  @override
  read(BinaryReader reader) {
    final json = reader.read() as Map<dynamic, dynamic>;
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      chapter: json['chapter'],
      size: json['size'],
      isDownloaded: json['is_downloaded'],
    );
  }

  @override
  int get typeId => 4;

  @override
  void write(BinaryWriter writer, Note obj) {
    writer.write(obj.toJson());
  }
}
