import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/get_astronomy_picture.dart';
import 'apod_event.dart';
import 'apod_state.dart';

@injectable
class ApodBloc extends Bloc<ApodEvent, ApodState> {
  final GetAstronomyPicture _getAstronomyPicture;

  ApodBloc({
    required GetAstronomyPicture getAstronomyPicture,
  })  : _getAstronomyPicture = getAstronomyPicture,
        super(ApodInitial()) {
    
    on<ApodRequested>(_onApodRequested);
  }

  Future<void> _onApodRequested(
    ApodRequested event,
    Emitter<ApodState> emit,
  ) async {
    emit(ApodLoading());

    final result = await _getAstronomyPicture(
      GetAstronomyPictureParams(date: event.date),
    );

    result.fold(
      (failure) => emit(ApodFailure(message: failure.message)),
      (picture) => emit(ApodSuccess(astronomyPicture: picture)),
    );
  }
}