import 'dart:convert';
import 'package:cosmos_odyssey/core/di/injection.dart';
import 'package:cosmos_odyssey/features/apod/presentation/pages/apod_page.dart';
import 'package:cosmos_odyssey/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClientAdapter extends Mock implements HttpClientAdapter {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Dio dio;
  late MockHttpClientAdapter mockAdapter;

  setUp(() async {
    await getIt.reset();

    mockAdapter = MockHttpClientAdapter();
    registerFallbackValue(RequestOptions(path: ''));

    await dotenv.load(fileName: ".env");
    dotenv.env['NASA_API_KEY'] = 'TEST_KEY';
    dotenv.env['BASE_URL'] = 'https://api.nasa.gov/';

    dio = Dio(BaseOptions(baseUrl: dotenv.env['BASE_URL']!));
    dio.httpClientAdapter = mockAdapter;

    configureDependencies();

    await getIt.unregister<Dio>();
    getIt.registerSingleton<Dio>(dio);
  });

  testWidgets('Should load APOD feature, show loading and then content', (
    tester,
  ) async {
    final successResponse = {
      "date": "2023-11-28",
      "explanation": "Integration Test Explanation",
      "hdurl": "https://example.com/hd.jpg",
      "media_type": "image",
      "service_version": "v1",
      "title": "Integration Test Title",
      "url": "https://example.com/image.jpg",
    };

    when(() => mockAdapter.fetch(any(), any(), any())).thenAnswer(
      (_) async => ResponseBody.fromString(
        jsonEncode(successResponse),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
    );

    await tester.pumpWidget(const CosmosOdysseyApp());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Integration Test Title'), findsOneWidget);
    expect(find.text('Integration Test Explanation'), findsOneWidget);
    expect(find.byType(ApodPage), findsOneWidget);
  });
}
