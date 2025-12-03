import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/astronomy_picture.dart';

abstract class ApodRepository {
  Future<Either<Failure, AstronomyPicture>> getAstronomyPicture({
    DateTime? date,
  });
}
