import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:cosmos_odyssey/features/apod/data/models/apod_model.dart';
import 'package:cosmos_odyssey/features/apod/domain/entities/astronomy_picture.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tApodModel = ApodModel(
    date: DateTime(2023, 11, 28),
    explanation: "Test explanation",
    mediaType: "image",
    title: "Test Title",
    url: "https://example.com/image.jpg",
    hdUrl: "https://example.com/image_hd.jpg",
  );

  test('should be a subclass of AstronomyPicture entity', () async {
    expect(tApodModel, isA<AstronomyPicture>());
  });

  group('fromJson', () {
    test(
      'should return a valid model when the JSON media_type is image',
      () async {
        final Map<String, dynamic> jsonMap = json.decode(fixture('apod.json'));

        final result = ApodModel.fromJson(jsonMap);

        expect(result, tApodModel);
      },
    );
  });
}
