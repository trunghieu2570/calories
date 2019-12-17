import 'package:equatable/equatable.dart';

abstract class FavoriteFoodsState extends Equatable {
  const FavoriteFoodsState();
  @override
  List<Object> get props => [];
}


class FavoriteFoodsLoading extends FavoriteFoodsState {}

class FavoriteFoodAdded extends FavoriteFoodsState {
  final String foodId;

  const FavoriteFoodAdded(this.foodId);

  @override
  List<Object> get props => [foodId];

  @override
  String toString() {
    return "FoodAdded $foodId";
  }
}

class FavoriteFoodsLoaded extends FavoriteFoodsState {
  final List<String> foodIds;

  const FavoriteFoodsLoaded(this.foodIds);

  @override
  List<Object> get props => [foodIds];

  @override
  String toString() {
    return "FavoriteFoodLoaded $foodIds";
  }
}

class FavoriteFoodsNotLoad extends FavoriteFoodsState {}