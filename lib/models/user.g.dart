// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  phoneNumber: json['phoneNumber'] as String,
  isPhoneVerified: json['isPhoneVerified'] as bool,
  grade: Grade.fromJson(json['grade'] as Map<String, dynamic>),
  stream: json['stream'] as String?,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'phoneNumber': instance.phoneNumber,
  'isPhoneVerified': instance.isPhoneVerified,
  'grade': instance.grade,
  'stream': instance.stream,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

AuthToken _$AuthTokenFromJson(Map<String, dynamic> json) =>
    AuthToken(token: json['token'] as String);

Map<String, dynamic> _$AuthTokenToJson(AuthToken instance) => <String, dynamic>{
  'token': instance.token,
};

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
  jwt: json['jwt'] as String,
  user: User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{'jwt': instance.jwt, 'user': instance.user};

RegisterResponse _$RegisterResponseFromJson(Map<String, dynamic> json) =>
    RegisterResponse(
      detail: json['detail'] as String,
      id: json['id'] as String,
    );

Map<String, dynamic> _$RegisterResponseToJson(RegisterResponse instance) =>
    <String, dynamic>{'detail': instance.detail, 'id': instance.id};

VerifyPhoneResponse _$VerifyPhoneResponseFromJson(Map<String, dynamic> json) =>
    VerifyPhoneResponse(
      jwt: json['jwt'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VerifyPhoneResponseToJson(
  VerifyPhoneResponse instance,
) => <String, dynamic>{'jwt': instance.jwt, 'user': instance.user};
