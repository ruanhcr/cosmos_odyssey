import 'package:equatable/equatable.dart';
import '../../domain/entities/astronomy_picture.dart';

sealed class ApodState extends Equatable {
  const ApodState();
  
  @override
  List<Object?> get props => [];
}

class ApodInitial extends ApodState {}

class ApodLoading extends ApodState {}

class ApodSuccess extends ApodState {
  final AstronomyPicture astronomyPicture;

  const ApodSuccess({required this.astronomyPicture});

  @override
  List<Object?> get props => [astronomyPicture];
}

class ApodFailure extends ApodState {
  final String message;

  const ApodFailure({required this.message});

  @override
  List<Object?> get props => [message];
}