import 'package:equatable/equatable.dart';

abstract class FavoriteMealsState extends Equatable {
  const FavoriteMealsState();
  @override
  List<Object> get props => [];
}


class FavoriteMealsLoading extends FavoriteMealsState {}

class FavoriteMealAdded extends FavoriteMealsState {
  final String mealId;

  const FavoriteMealAdded(this.mealId);

  @override
  List<Object> get props => [mealId];

  @override
  String toString() {
    return "MealAdded $mealId";
  }
}

class FavoriteMealsLoaded extends FavoriteMealsState {
  final List<String> mealIds;

  const FavoriteMealsLoaded(this.mealIds);

  @override
  List<Object> get props => [mealIds];

  @override
  String toString() {
    return "FavoriteMealLoaded $mealIds";
  }
}

class FavoriteMealsNotLoad extends FavoriteMealsState {}