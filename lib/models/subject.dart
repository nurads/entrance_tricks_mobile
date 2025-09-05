import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:entrance_tricks/models/models.dart';
part 'subject.g.dart';

@JsonSerializable()
class Subject {
  final int id;
  final String title;
  final String? icon;
  final String? description;
  final String createdAt;
  final String updatedAt;

  final List<Chapter>? chapters;

  Subject({
    required this.id,
    required this.title,
    this.icon,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.chapters,
  });

  factory Subject.fromJson(Map<String, dynamic> json) =>
      _$SubjectFromJson(json);
  Map<String, dynamic> toJson() => _$SubjectToJson(this);
}

class SubjectTypeAdapter implements TypeAdapter<Subject> {
  @override
  read(BinaryReader reader) {
    final json = reader.read() as Map<dynamic, dynamic>;
    return Subject(
      id: json['id'],
      title: json['title'],
      icon: json['icon'],
      description: json['description'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      chapters: json['chapters'],
    );
  }

  @override
  int get typeId => 14;

  @override
  void write(BinaryWriter writer, Subject obj) {
    writer.write(obj.toJson());
  }
}
