import 'package:calories/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object> get props => [];
}

class LoadRecipes extends RecipeEvent {}

class UpdateRecipes extends RecipeEvent {
  final List<Recipe> recipes;

  const UpdateRecipes(this.recipes);

  @override
  List<Object> get props => [recipes];

  @override
  String toString() {
    return "UpdateRecipes $recipes";
  }
}

class AddNewRecipe extends RecipeEvent {
  final Recipe recipe;

  const AddNewRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];

  @override
  String toString() {
    return "AddNewRecipe $recipe";
  }
}

class UpdateRecipe extends RecipeEvent {
  final Recipe recipe;

  const UpdateRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];

  @override
  String toString() {
    return "UpdateRecipe $recipe";
  }
}

class DeleteRecipe extends RecipeEvent {
  final Recipe recipe;

  const DeleteRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];

  @override
  String toString() {
    return "DeleteRecipe $recipe";
  }
}
