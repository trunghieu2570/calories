import 'package:calories/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class DailyMealEvent extends Equatable {
  const DailyMealEvent();

  @override
  List<Object> get props => [];
}

class AddDailyMeal extends DailyMealEvent {
  final DailyMeal dailyMeal;

  const AddDailyMeal(this.dailyMeal);

  @override
  List<Object> get props => [dailyMeal];

  @override
  String toString() {
    return "Add daily meal $dailyMeal";
  }
}

class DeleteDailyMeal extends DailyMealEvent {
  final DailyMeal dailyMeal;

  const DeleteDailyMeal(this.dailyMeal);

  @override
  List<Object> get props => [dailyMeal];

  @override
  String toString() {
    return "Delete daily meal $dailyMeal";
  }
}

class UpdateDailyMeal extends DailyMealEvent {
  final DailyMeal dailyMeal;

  const UpdateDailyMeal(this.dailyMeal);

  @override
  List<Object> get props => [dailyMeal];

  @override
  String toString() {
    return "Update daily meal $dailyMeal";
  }
}

class DailyMealsUpdated extends DailyMealEvent {
  final List<DailyMeal> dailyMeals;

  const DailyMealsUpdated(this.dailyMeals);

  @override
  List<Object> get props => [dailyMeals];
}

class LoadDailyMeals extends DailyMealEvent {}