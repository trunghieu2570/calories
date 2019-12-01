import 'package:calories/models/food_model.dart';

abstract class FoodRepository {
  Future<String> addNewFood(Food food);
  Future<void> updateFood(Food food);
  Future<void> deleteFood(Food food);
  Stream<List<Food>> getFoods();
}