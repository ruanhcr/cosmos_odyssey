// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/apod/data/datasources/apod_remote_data_source.dart'
    as _i830;
import '../../features/apod/data/repositories/apod_repository_impl.dart'
    as _i418;
import '../../features/apod/domain/repositories/apod_repository.dart' as _i51;
import '../../features/apod/domain/usecases/get_astronomy_picture.dart'
    as _i129;
import '../../features/apod/presentation/bloc/apod_bloc.dart' as _i461;
import '../log/app_logger.dart' as _i564;
import '../log/logger_app_logger_impl.dart' as _i700;
import '../network/network_module.dart' as _i200;
import '../ui/styles/app_typography.dart' as _i894;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio);
    gh.singleton<_i894.AppTypography>(() => _i894.GoogleAppTypography());
    gh.singleton<_i564.AppLogger>(() => _i700.LoggerAppLoggerImpl());
    gh.lazySingleton<_i830.ApodRemoteDataSource>(
      () => _i830.ApodRemoteDataSource(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i51.ApodRepository>(
      () => _i418.ApodRepositoryImpl(
        remoteDataSource: gh<_i830.ApodRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i129.GetAstronomyPicture>(
      () => _i129.GetAstronomyPicture(repository: gh<_i51.ApodRepository>()),
    );
    gh.factory<_i461.ApodBloc>(
      () =>
          _i461.ApodBloc(getAstronomyPicture: gh<_i129.GetAstronomyPicture>()),
    );
    return this;
  }
}

class _$NetworkModule extends _i200.NetworkModule {}
