import 'package:cosmos_odyssey/core/usecase/use_case.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/astronomy_picture.dart';
import '../repositories/apod_repository.dart';

@lazySingleton
class GetAstronomyPicture
    implements UseCase<AstronomyPicture, GetAstronomyPictureParams> {
  final ApodRepository _repository;

  GetAstronomyPicture({required ApodRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, AstronomyPicture>> call(
    GetAstronomyPictureParams params,
  ) async {
    return await _repository.getAstronomyPicture(date: params.date);
  }
}

class GetAstronomyPictureParams {
  final DateTime? date;
  const GetAstronomyPictureParams({this.date});
}
