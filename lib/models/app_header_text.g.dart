// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_header_text.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppHeaderText _$AppHeaderTextFromJson(Map<String, dynamic> json) =>
    AppHeaderText(
      text: json['text'] as String,
      gradientStart: json['gradient_start_color'] as String?,
      gradientEnd: json['gradient_end_color'] as String?,
      link: json['telegram_channel_url'] as String?,
    );

Map<String, dynamic> _$AppHeaderTextToJson(AppHeaderText instance) =>
    <String, dynamic>{
      'text': instance.text,
      'gradient_start_color': instance.gradientStart,
      'gradient_end_color': instance.gradientEnd,
      'telegram_channel_url': instance.link,
    };
