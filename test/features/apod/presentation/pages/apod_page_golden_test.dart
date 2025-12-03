import 'package:bloc_test/bloc_test.dart';
import 'package:cosmos_odyssey/core/di/injection.dart';
import 'package:cosmos_odyssey/core/ui/styles/app_typography.dart';
import 'package:cosmos_odyssey/features/apod/domain/entities/astronomy_picture.dart';
import 'package:cosmos_odyssey/features/apod/presentation/bloc/apod_bloc.dart';
import 'package:cosmos_odyssey/features/apod/presentation/bloc/apod_event.dart';
import 'package:cosmos_odyssey/features/apod/presentation/bloc/apod_state.dart';
import 'package:cosmos_odyssey/features/apod/presentation/pages/apod_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';

class MockApodBloc extends MockBloc<ApodEvent, ApodState> implements ApodBloc {}

class MockAppTypography extends Mock implements AppTypography {}

void main() {
  late MockApodBloc mockBloc;
  late AppTypography realTypography;

  setUpAll(() {
    registerFallbackValue(ApodInitial());
    registerFallbackValue(Colors.transparent);
  });

  setUp(() async {
    await getIt.reset();
    mockBloc = MockApodBloc();

    realTypography = GoogleAppTypography();

    getIt.registerFactory<ApodBloc>(() => mockBloc);
    getIt.registerSingleton<AppTypography>(realTypography);
  });

  final tAstronomyPicture = AstronomyPicture(
    date: DateTime(2023, 11, 28),
    explanation:
        "This is a visual test to ensure our typography and layout look amazing on all devices.",
    mediaType: "image",
    title: "Cosmos Odyssey Design System",
    url: "https://example.com/image.jpg",
  );

  testGoldens('ApodPage - Success State Visual Regression', (tester) async {
    when(
      () => mockBloc.state,
    ).thenReturn(ApodSuccess(astronomyPicture: tAstronomyPicture));

    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(
        devices: [Device.phone, Device.iphone11, Device.tabletPortrait],
      )
      ..addScenario(widget: const ApodPage(), name: 'apod_success_page');

    await tester.pumpDeviceBuilder(builder);

    await screenMatchesGolden(tester, 'apod_page_success');
  });
}
