import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmos_odyssey/core/di/injection.dart';
import 'package:cosmos_odyssey/core/ui/styles/app_typography.dart';
import 'package:cosmos_odyssey/features/apod/domain/entities/astronomy_picture.dart';
import 'package:cosmos_odyssey/features/apod/presentation/bloc/apod_bloc.dart';
import 'package:cosmos_odyssey/features/apod/presentation/bloc/apod_event.dart';
import 'package:cosmos_odyssey/features/apod/presentation/bloc/apod_state.dart';
import 'package:cosmos_odyssey/features/apod/presentation/pages/apod_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


class MockApodBloc extends MockBloc<ApodEvent, ApodState> implements ApodBloc {}

class MockAppTypography extends Mock implements AppTypography {}

class FakeApodEvent extends Fake implements ApodEvent {}

void main() {
  late MockApodBloc mockBloc;
  late MockAppTypography mockTypography;

  setUpAll(() {
    registerFallbackValue(FakeApodEvent());
    registerFallbackValue(ApodInitial());
    registerFallbackValue(Colors.transparent); 
    registerFallbackValue(FontWeight.normal);
  });

  setUp(() async {
    await getIt.reset();

    mockBloc = MockApodBloc();
    mockTypography = MockAppTypography();

    getIt.registerFactory<ApodBloc>(() => mockBloc);
    getIt.registerSingleton<AppTypography>(mockTypography);

    when(
      () => mockTypography.heading(
        fontSize: any(named: 'fontSize'),
        color: any(named: 'color'),
        fontWeight: any(named: 'fontWeight'),
      ),
    ).thenReturn(const TextStyle());

    when(
      () => mockTypography.body(
        fontSize: any(named: 'fontSize'),
        color: any(named: 'color'),
        height: any(named: 'height'),
      ),
    ).thenReturn(const TextStyle());
  });

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(home: body);
  }

  final tAstronomyPicture = AstronomyPicture(
    date: DateTime(2023, 11, 28),
    explanation: "Test explanation",
    mediaType: "image",
    title: "Test Title",
    url: "https://example.com/image.jpg",
  );

  group('ApodPage', () {
    testWidgets('should render ApodView and trigger initial event', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(ApodInitial());

      await tester.pumpWidget(makeTestableWidget(const ApodPage()));

      expect(find.byType(ApodView), findsOneWidget);
      verify(() => mockBloc.add(const ApodRequested())).called(1);
    });
  });

  group('ApodView', () {
    testWidgets('should display loading indicator when state is ApodLoading', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(ApodLoading());

      await tester.pumpWidget(
        makeTestableWidget(
          BlocProvider<ApodBloc>.value(
            value: mockBloc,
            child: const ApodView(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
      'should display error message and retry button when state is ApodFailure',
      (tester) async {
        const errorMessage = 'Something went wrong';
        when(
          () => mockBloc.state,
        ).thenReturn(const ApodFailure(message: errorMessage));

        await tester.pumpWidget(
          makeTestableWidget(
            BlocProvider<ApodBloc>.value(
              value: mockBloc,
              child: const ApodView(),
            ),
          ),
        );

        expect(find.text(errorMessage), findsOneWidget);
        expect(find.text('Try Again'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);

        await tester.tap(find.text('Try Again'));
        verify(() => mockBloc.add(const ApodRequested())).called(1);
      },
    );

    testWidgets(
      'should display image content when state is ApodSuccess with image',
      (tester) async {
        when(
          () => mockBloc.state,
        ).thenReturn(ApodSuccess(astronomyPicture: tAstronomyPicture));

        await tester.pumpWidget(
          makeTestableWidget(
            BlocProvider<ApodBloc>.value(
              value: mockBloc,
              child: const ApodView(),
            ),
          ),
        );

        expect(find.text(tAstronomyPicture.title), findsOneWidget);
        expect(find.text(tAstronomyPicture.explanation), findsOneWidget);
        expect(find.byType(CachedNetworkImage), findsOneWidget);
      },
    );

    testWidgets(
      'should display video placeholder when state is ApodSuccess with video',
      (tester) async {
        final tVideoPicture = AstronomyPicture(
          date: DateTime.now(),
          explanation: "Video desc",
          mediaType: "video",
          title: "Video Title",
          url: "https://youtube.com/video",
        );

        when(
          () => mockBloc.state,
        ).thenReturn(ApodSuccess(astronomyPicture: tVideoPicture));

        await tester.pumpWidget(
          makeTestableWidget(
            BlocProvider<ApodBloc>.value(
              value: mockBloc,
              child: const ApodView(),
            ),
          ),
        );

        expect(find.text('Video Content Available on Web'), findsOneWidget);
        expect(find.byType(CachedNetworkImage), findsNothing);
      },
    );
  });
}
