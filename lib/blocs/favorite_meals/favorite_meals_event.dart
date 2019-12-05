import 'package:equatable/equatable.dart';

abstract class FavoriteMealsEvent extends Equatable {
  const FavoriteMealsEvent();

  @override
  List<Object> get props => [];
}

class AddFavoriteMeal extends FavoriteMealsEvent {
  final String mealId;

  const AddFavoriteMeal(this.mealId);

  @override
  List<Object> get props => [mealId];

  @override
  String toString() {
    return "Add favorite meal $mealId";
  }
}

class DeleteFavoriteMeal extends FavoriteMealsEvent {
  final String mealId;

  const DeleteFavoriteMeal(this.mealId);

  @override
  List<Object> get props => [mealId];

  @override
  String toString() {
    return "Delete favorite meal $mealId";
  }
}

class FavoriteMealsUpdated extends FavoriteMealsEvent {
  final List<String> favoriteMeals;

  const FavoriteMealsUpdated(this.favoriteMeals);

  @override
  List<Object> get props => [favoriteMeals];
}

class LoadFavoriteMeals extends FavoriteMealsEvent {}