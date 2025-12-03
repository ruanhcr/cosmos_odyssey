import 'package:cosmos_odyssey/features/apod/domain/entities/astronomy_picture.dart';
import 'package:cosmos_odyssey/features/apod/domain/repositories/apod_repository.dart';
import 'package:cosmos_odyssey/features/apod/domain/usecases/get_astronomy_picture.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockApodRepository extends Mock implements ApodRepository {}

void main() {
  late GetAstronomyPicture usecase;
  late MockApodRepository mockApodRepository;

  setUp(() {
    mockApodRepository = MockApodRepository();
    usecase = GetAstronomyPicture(repository: mockApodRepository);
  });

  final tDate = DateTime(2023, 12, 01);
  final tAstronomyPicture = AstronomyPicture(
    date: tDate,
    explanation: 'Test',
    mediaType: 'image',
    title: 'Test',
    url: 'url',
  );

  test('should get astronomy picture from the repository', () async {
    when(
      () => mockApodRepository.getAstronomyPicture(date: tDate),
    ).thenAnswer((_) async => Right(tAstronomyPicture));

    final result = await usecase(GetAstronomyPictureParams(date: tDate));

    expect(result, Right(tAstronomyPicture));
    verify(() => mockApodRepository.getAstronomyPicture(date: tDate)).called(1);
    verifyNoMoreInteractions(mockApodRepository);
  });
}
