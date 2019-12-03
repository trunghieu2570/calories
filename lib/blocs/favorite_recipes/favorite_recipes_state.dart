import 'package:equatable/equatable.dart';

abstract class FavoriteRecipesState extends Equatable {
  const FavoriteRecipesState();
  @override
  List<Object> get props => [];
}


class FavoriteRecipesLoading extends FavoriteRecipesState {}

class FavoriteRecipeAdded extends FavoriteRecipesState {
  final String recipeId;

  const FavoriteRecipeAdded(this.recipeId);

  @override
  List<Object> get props => [recipeId];

  @override
  String toString() {
    return "RecipeAdded $recipeId";
  }
}

class FavoriteRecipesLoaded extends FavoriteRecipesState {
  final List<String> recipeIds;

  const FavoriteRecipesLoaded(this.recipeIds);

  @override
  List<Object> get props => [recipeIds];

  @override
  String toString() {
    return "FavoriteRecipeLoaded $recipeIds";
  }
}

class FavoriteRecipesNotLoad extends FavoriteRecipesState {}
