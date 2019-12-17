import 'package:equatable/equatable.dart';

abstract class HomeLoadState extends Equatable {
  const HomeLoadState();

  @override
  List<Object> get props => [];
}

class InitLoadState extends HomeLoadState {}

class HomeLoadedState extends HomeLoadState {}
