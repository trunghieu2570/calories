import 'package:equatable/equatable.dart';

abstract class FavoriteRecipesEvent extends Equatable {
  const FavoriteRecipesEvent();

  @override
  List<Object> get props => [];
}

class AddFavoriteRecipe extends FavoriteRecipesEvent {
  final String recipeId;

  const AddFavoriteRecipe(this.recipeId);

  @override
  List<Object> get props => [recipeId];

  @override
  String toString() {
    return "Add favorite recipe $recipeId";
  }
}

class DeleteFavoriteRecipe extends FavoriteRecipesEvent {
  final String recipeId;

  const DeleteFavoriteRecipe(this.recipeId);

  @override
  List<Object> get props => [recipeId];

  @override
  String toString() {
    return "Delete favorite recipe $recipeId";
  }
}

class FavoriteRecipesUpdated extends FavoriteRecipesEvent {
  final List<String> favoriteRecipes;

  const FavoriteRecipesUpdated(this.favoriteRecipes);

  @override
  List<Object> get props => [favoriteRecipes];
}

class LoadFavoriteRecipes extends FavoriteRecipesEvent {}
