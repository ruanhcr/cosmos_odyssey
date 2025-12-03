import 'package:bloc_test/bloc_test.dart';
import 'package:cosmos_odyssey/core/error/failures.dart';
import 'package:cosmos_odyssey/features/apod/domain/entities/astronomy_picture.dart';
import 'package:cosmos_odyssey/features/apod/domain/usecases/get_astronomy_picture.dart';
import 'package:cosmos_odyssey/features/apod/presentation/bloc/apod_bloc.dart';
import 'package:cosmos_odyssey/features/apod/presentation/bloc/apod_event.dart';
import 'package:cosmos_odyssey/features/apod/presentation/bloc/apod_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAstronomyPicture extends Mock implements GetAstronomyPicture {}

void main() {
  late ApodBloc bloc;
  late MockGetAstronomyPicture mockGetAstronomyPicture;

  setUp(() {
    mockGetAstronomyPicture = MockGetAstronomyPicture();
    bloc = ApodBloc(getAstronomyPicture: mockGetAstronomyPicture);
  });

  setUpAll(() {
    registerFallbackValue(const GetAstronomyPictureParams());
  });

  final tAstronomyPicture = AstronomyPicture(
    date: DateTime.now(),
    explanation: 'test',
    mediaType: 'image',
    title: 'test',
    url: 'url',
  );

  test('initial state should be ApodInitial', () {
    expect(bloc.state, equals(ApodInitial()));
  });

  group('ApodRequested', () {
    blocTest<ApodBloc, ApodState>(
      'should emit [ApodLoading, ApodSuccess] when data is gotten successfully',
      build: () {
        when(() => mockGetAstronomyPicture(any()))
            .thenAnswer((_) async => Right(tAstronomyPicture));
        return bloc;
      },
      act: (bloc) => bloc.add(const ApodRequested()),
      expect: () => [
        ApodLoading(),
        ApodSuccess(astronomyPicture: tAstronomyPicture),
      ],
      verify: (_) {
        verify(() => mockGetAstronomyPicture(any())).called(1);
      },
    );

    blocTest<ApodBloc, ApodState>(
      'should emit [ApodLoading, ApodFailure] when getting data fails',
      build: () {
        when(() => mockGetAstronomyPicture(any()))
            .thenAnswer((_) async => const Left(ServerFailure(message: 'Server Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const ApodRequested()),
      expect: () => [
        ApodLoading(),
        const ApodFailure(message: 'Server Error'),
      ],
    );
  });
}