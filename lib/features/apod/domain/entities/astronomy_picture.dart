import 'package:equatable/equatable.dart';

class AstronomyPicture extends Equatable {
  final DateTime date;
  final String explanation;
  final String? hdUrl;
  final String mediaType;
  final String title;
  final String url;

  const AstronomyPicture({
    required this.date,
    required this.explanation,
    this.hdUrl,
    required this.mediaType,
    required this.title,
    required this.url,
  });

  bool get isImage => mediaType == 'image';

  @override
  List<Object?> get props => [date, explanation, hdUrl, mediaType, title, url];
}
