// ignore_for_file: overridden_fields

import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/astronomy_picture.dart';

part 'apod_model.g.dart';

@JsonSerializable()
class ApodModel extends AstronomyPicture {
  @override
  @JsonKey(name: 'media_type')
  final String mediaType;

  @override
  @JsonKey(name: 'hdurl')
  final String? hdUrl;

  const ApodModel({
    required super.date,
    required super.explanation,
    required this.hdUrl,
    required this.mediaType,
    required super.title,
    required super.url,
  }) : super(mediaType: mediaType, hdUrl: hdUrl);

  factory ApodModel.fromJson(Map<String, dynamic> json) =>
      _$ApodModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApodModelToJson(this);
}
