import 'package:calories/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class MealState extends Equatable {
  const MealState();
  @override
  List<Object> get props => [];
}

class MealsLoading extends MealState {}

class MealsLoaded extends MealState {
  final List<Meal> meals;
  const MealsLoaded(this.meals);

  @override
  List<Object> get props => [meals];
  @override
  String toString() {
    return "MealsLoaded $meals";
  }
}

class MealsNotLoad extends MealState {}

