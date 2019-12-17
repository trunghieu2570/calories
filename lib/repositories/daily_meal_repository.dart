import 'package:calories/models/models.dart';

abstract class DailyMealsRepository {
  Future<String> addNewDailyMeal(String uid, DailyMeal meal);

  Future<void> updateDailyMeal(String uid, DailyMeal meal);

  Future<void> deleteDailyMeal(String uid, DailyMeal meal);

  Stream<List<DailyMeal>> getDailyMeals(String uid);
}
