import 'package:cosmos_odyssey/core/config/env.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/astronomy_picture.dart';
import '../../domain/repositories/apod_repository.dart';
import '../datasources/apod_remote_data_source.dart';

@LazySingleton(as: ApodRepository)
class ApodRepositoryImpl implements ApodRepository {
  final ApodRemoteDataSource _remoteDataSource;

  ApodRepositoryImpl({required ApodRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, AstronomyPicture>> getAstronomyPicture({
    DateTime? date,
  }) async {
    final String? dateString = date != null
        ? DateFormat('yyyy-MM-dd').format(date)
        : null;

    try {
      final result = await _remoteDataSource.getAstronomyPicture(
        apiKey: Env.nasaApiKey,
        date: dateString,
      );

      return Right(result);
    } on DioException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'Erro na comunicação com a API'),
      );
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
