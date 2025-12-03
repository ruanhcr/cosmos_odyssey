import 'package:cosmos_odyssey/core/error/failures.dart';
import 'package:cosmos_odyssey/features/apod/data/datasources/apod_remote_data_source.dart';
import 'package:cosmos_odyssey/features/apod/data/models/apod_model.dart';
import 'package:cosmos_odyssey/features/apod/data/repositories/apod_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockApodRemoteDataSource extends Mock implements ApodRemoteDataSource {}

void main() {
  late ApodRepositoryImpl repository;
  late MockApodRemoteDataSource mockRemoteDataSource;

  setUpAll(() async {
    try {
      await dotenv.load(fileName: ".env");
    } catch (_) {}

    dotenv.env['NASA_API_KEY'] = 'TEST_KEY';
    dotenv.env['BASE_URL'] = 'https://api.nasa.gov/';
  });

  setUp(() {
    mockRemoteDataSource = MockApodRemoteDataSource();
    repository = ApodRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  final tDate = DateTime(2023, 12, 01);
  final tApodModel = ApodModel(
    date: DateTime(2023, 12, 01),
    explanation: 'desc',
    mediaType: 'image',
    title: 'title',
    url: 'url',
    hdUrl: 'hdurl',
  );

  group('getAstronomyPicture', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        when(
          () => mockRemoteDataSource.getAstronomyPicture(
            apiKey: any(named: 'apiKey'),
            date: any(named: 'date'),
          ),
        ).thenAnswer((_) async => tApodModel);

        final result = await repository.getAstronomyPicture(date: tDate);

        verify(
          () => mockRemoteDataSource.getAstronomyPicture(
            apiKey: any(named: 'apiKey'),
            date: '2023-12-01',
          ),
        );
        expect(result, equals(Right(tApodModel)));
      },
    );

    test(
      'should return ServerFailure when the call to remote data source is unsuccessful',
      () async {
        when(
          () => mockRemoteDataSource.getAstronomyPicture(
            apiKey: any(named: 'apiKey'),
            date: any(named: 'date'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.badResponse,
            message: 'Not Found',
          ),
        );

        final result = await repository.getAstronomyPicture(date: tDate);

        expect(result, equals(const Left(ServerFailure(message: 'Not Found'))));
      },
    );
  });
}
