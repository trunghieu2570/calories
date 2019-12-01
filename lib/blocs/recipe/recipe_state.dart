import 'package:calories/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object> get props => [];
}

class RecipesLoading extends RecipeState {}

class RecipesLoaded extends RecipeState {
  final List<Recipe> recipes;

  const RecipesLoaded(this.recipes);

  @override
  List<Object> get props => [recipes];

  @override
  String toString() {
    return "$recipes";
  }
}

class RecipesNotLoad extends RecipeState {}