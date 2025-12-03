import 'package:equatable/equatable.dart';

abstract class ApodEvent extends Equatable {
  const ApodEvent();

  @override
  List<Object?> get props => [];
}

class ApodRequested extends ApodEvent {
  final DateTime? date;

  const ApodRequested({this.date});

  @override
  List<Object?> get props => [date];
}