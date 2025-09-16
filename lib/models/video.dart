import 'package:json_annotation/json_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'video.g.dart';

@JsonSerializable()
class Video {
  final int id;
  final String title;
  final String url;
  final String duration;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? image;
  @JsonKey(name: 'is_locked')
  final bool isLocked;
  final String? description;
  @JsonKey(name: 'is_watched')
  final bool isWatched;
  bool isDownloaded;

  Video({
    required this.id,
    required this.title,
    required this.url,
    required this.duration,
    required this.createdAt,
    required this.updatedAt,
    this.isLocked = true,
    this.isWatched = false,
    this.image,
    this.description,
    this.isDownloaded = false,
  });

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);
  Map<String, dynamic> toJson() => _$VideoToJson(this);
}

class VideoTypeAdapter implements TypeAdapter<Video> {
  @override
  read(BinaryReader reader) {
    final json = reader.read() as Map<dynamic, dynamic>;
    final json_ = Map<String, dynamic>.from(json);
    return Video.fromJson(json_);
  }

  @override
  int get typeId => 9;

  @override
  void write(BinaryWriter writer, Video obj) {
    writer.write(obj.toJson());
  }
}
