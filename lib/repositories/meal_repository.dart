import 'package:calories/models/models.dart';

abstract class MealRepository {
  Future<String> addNewMeal(Meal meal);
  Future<void> deleteMeal(Meal meal);
  Future<void> updateMeal(Meal meal);
  Stream<List<Meal>> getMeals();
}