import 'package:json_annotation/json_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:entrance_tricks/models/models.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String phoneNumber;
  final bool isPhoneVerified;
  final Grade grade;
  final String? stream;
  final String createdAt;
  final String updatedAt;
  User({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.isPhoneVerified,
    required this.grade,
    required this.stream,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class AuthToken {
  final String token;
  // final String refreshToken;

  AuthToken({required this.token});

  factory AuthToken.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenFromJson(json);
  Map<String, dynamic> toJson() => _$AuthTokenToJson(this);
}

@JsonSerializable()
class AuthResponse {
  final String jwt;
  final User user;

  AuthResponse({required this.jwt, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

@JsonSerializable()
class RegisterResponse {
  final String detail;
  final String id;

  RegisterResponse({required this.detail, required this.id});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}

@JsonSerializable()
class VerifyPhoneResponse {
  final String jwt;
  final User user;

  VerifyPhoneResponse({required this.jwt, required this.user});

  factory VerifyPhoneResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyPhoneResponseFromJson(json);
  Map<String, dynamic> toJson() => _$VerifyPhoneResponseToJson(this);
}

class UserTypeAdapter implements TypeAdapter<User> {
  @override
  read(BinaryReader reader) {
    final json = reader.read() as Map<dynamic, dynamic>;

    return User(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      isPhoneVerified: json['isPhoneVerified'],
      grade: json['grade'],
      stream: json['stream'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  @override
  int get typeId => 13;

  @override
  void write(BinaryWriter writer, User obj) {
    writer.write(obj.toJson());
  }
}
