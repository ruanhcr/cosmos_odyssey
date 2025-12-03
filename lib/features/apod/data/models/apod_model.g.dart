// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apod_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApodModel _$ApodModelFromJson(Map<String, dynamic> json) => ApodModel(
  date: DateTime.parse(json['date'] as String),
  explanation: json['explanation'] as String,
  hdUrl: json['hdurl'] as String?,
  mediaType: json['media_type'] as String,
  title: json['title'] as String,
  url: json['url'] as String,
);

Map<String, dynamic> _$ApodModelToJson(ApodModel instance) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'explanation': instance.explanation,
  'title': instance.title,
  'url': instance.url,
  'media_type': instance.mediaType,
  'hdurl': instance.hdUrl,
};
