import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../models/apod_model.dart';

part 'apod_remote_data_source.g.dart';

@lazySingleton
@RestApi()
abstract class ApodRemoteDataSource {
  @factoryMethod
  factory ApodRemoteDataSource(Dio dio) = _ApodRemoteDataSource;

  @GET('planetary/apod')
  Future<ApodModel> getAstronomyPicture({
    @Query('api_key') required String apiKey,
    @Query('date') String? date,
  });
}