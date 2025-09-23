import 'package:json_annotation/json_annotation.dart';
import 'package:entrance_tricks/models/models.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'exam.g.dart';

@JsonSerializable()
class Exam {
  final int id;
  final String name;
  @JsonKey(name: 'exam_type')
  final String examType;
  final String? year;
  @JsonKey(name: 'total_questions')
  final int? totalQuestions;
  @JsonKey(name: 'given_time_in_minutes')
  final int duration;
  @JsonKey(name: 'is_locked')
  final bool isLocked;
  final Subject? subject;
  final String? image;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'is_downloaded')
  bool isDownloaded;

  List<Question> questions;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isLoadingQuestion = false;

  Exam({
    required this.id,
    required this.name,
    required this.examType,
    this.year,
    this.totalQuestions,
    required this.duration,
    required this.isLocked,
    this.subject,
    this.image,
    required this.createdAt,
    required this.updatedAt,
    this.isDownloaded = false,
    this.questions = const [],
  });

  factory Exam.fromJson(Map<String, dynamic> json) => _$ExamFromJson(json);
  Map<String, dynamic> toJson() => _$ExamToJson(this);

  // Helper getter for display
  String get title => name;
}

class ExamTypeAdapter implements TypeAdapter<Exam> {
  @override
  read(BinaryReader reader) {
    final json = reader.read() as Map<dynamic, dynamic>;
    final json_ = Map<String, dynamic>.from(json);
    return Exam(
      id: json_['id'],
      name: json_['name'],
      examType: json_['exam_type'],
      duration: json_['given_time_in_minutes'],
      isLocked: json_['is_locked'],
      createdAt: DateTime.parse(json_['created_at']),
      updatedAt: DateTime.parse(json_['updated_at']),
      isDownloaded: json_['is_downloaded'] ?? false,
      subject: json_['subject'],
      image: json_['image'],
      totalQuestions: json_['total_questions'],
      year: json_['year'],
    );
  }

  @override
  int get typeId => 2;
  @override
  void write(BinaryWriter writer, Exam obj) {
    writer.write(obj.toJson());
  }
}
