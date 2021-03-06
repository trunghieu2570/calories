import 'package:calories/models/models.dart';

abstract class RecipeRepository {
  Future<String> addNewRecipe(Recipe recipe);
  Future<void> updateRecipe(Recipe recipe);
  Future<void> deleteRecipe(Recipe recipe);
  Stream<List<Recipe>> getRecipes();
}