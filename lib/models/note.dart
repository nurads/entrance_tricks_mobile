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
  bool isDownloaded;

  @JsonKey(name: 'file_path')
  String? filePath;

  final int? size;

  // Add these new properties for download progress
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isDownloading = false;

  @JsonKey(includeFromJson: false, includeToJson: false)
  double downloadProgress = 0.0;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.chapter,
    this.size = 0,
    this.filePath,
    this.isDownloaded = false,
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
      filePath: json['file_path'],
    );
  }

  @override
  int get typeId => 4;

  @override
  void write(BinaryWriter writer, Note obj) {
    writer.write(obj.toJson());
  }
}
