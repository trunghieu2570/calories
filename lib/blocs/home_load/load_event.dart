import 'package:equatable/equatable.dart';

abstract class HomeLoadEvent extends Equatable {
  const HomeLoadEvent();

  @override
  List<Object> get props => [];
}

class StartHomeLoad extends HomeLoadEvent {}

class HomeLoaded extends HomeLoadEvent {}
