import 'package:calories/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class MealEvent extends Equatable {
  const MealEvent();
  @override
  List<Object> get props => [];
}

class AddMeal extends MealEvent {
  final Meal meal;
  const AddMeal(this.meal);
  @override
  List<Object> get props => [meal];
  @override
  String toString() {
    return "AddMeal $meal";
  }
}

class DeleteMeal extends MealEvent {
  final Meal meal;
  const DeleteMeal(this.meal);
  @override
  List<Object> get props => [meal];
  @override
  String toString() {
    return "DeleteMeal $meal";
  }
}

class UpdateMeal extends MealEvent {
  final Meal meal;
  const UpdateMeal(this.meal);
  @override
  List<Object> get props => [meal];
  @override
  String toString() {
    return "UpdateMeal $meal";
  }
}

class MealsUpdated extends MealEvent {
  final List<Meal> meals;
  const MealsUpdated(this.meals);
  @override
  List<Object> get props => [meals];
  @override
  String toString() {
    return "MealsUpdated $meals";
  }
}

class LoadMeals extends MealEvent {}