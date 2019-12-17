import 'package:calories/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class DailyMealState extends Equatable {
  const DailyMealState();
  @override
  List<Object> get props => [];
}


class DailyMealsLoading extends DailyMealState {}

class DailyMealAdded extends DailyMealState {
  final DailyMeal dailyMeal;

  const DailyMealAdded(this.dailyMeal);

  @override
  List<Object> get props => [dailyMeal];

  @override
  String toString() {
    return "DailyMealAdded $dailyMeal";
  }
}

class DailyMealsLoaded extends DailyMealState {
  final List<DailyMeal> dailyMeals;

  const DailyMealsLoaded(this.dailyMeals);

  @override
  List<Object> get props => [dailyMeals];

  @override
  String toString() {
    return "DailyMealsLoaded $dailyMeals";
  }
}

class DailyMealNotLoad extends DailyMealState {}