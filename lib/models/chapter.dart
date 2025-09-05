import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chapter.g.dart';

@JsonSerializable()
class Chapter {
  final int id;
  final int chapterNumber;
  final String title;
  final String? description;
  final String createdAt;
  final String updatedAt;
  final bool isLocked;
  final List notes;
  final List quizzes;
  final List videos;

  Chapter({
    required this.id,
    required this.chapterNumber,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.isLocked = false,
    this.notes = const [],
    this.quizzes = const [],
    this.videos = const [],
  });

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);
  Map<String, dynamic> toJson() => _$ChapterToJson(this);
}

class ChapterTypeAdapter implements TypeAdapter<Chapter> {
  @override
  read(BinaryReader reader) {
    final json = reader.read() as Map<dynamic, dynamic>;
    return Chapter(
      id: json['id'],
      chapterNumber: json['chapterNumber'] ?? 1,
      title: json['title'],
      description: json['description'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      isLocked: json['isLocked'] ?? false,
      notes: json['notes'] ?? [],
      quizzes: json['quizzes'] ?? [],
      videos: json['videos'] ?? [],
    );
  }

  @override
  int get typeId => 15;

  @override
  void write(BinaryWriter writer, Chapter obj) {
    writer.write(obj.toJson());
  }
}
