import 'package:calories/entities/entities.dart';
import 'package:equatable/equatable.dart';

class Recipe extends Equatable {
  final String id;
  final String title;
  final int numberOfServings;
  final String photoUrl;
  final List<Ingredient> ingredients;
  final List<Direction> directions;
  final List<String> tags;

  Recipe(this.title, this.numberOfServings,
      {this.id, this.photoUrl, this.ingredients, this.directions, this.tags});

  @override
  List<Object> get props =>
      [id, title, numberOfServings, photoUrl, ingredients, tags];

  RecipeEntity toEntity() {
    List<IngredientEntity> ingredientEntityList =
        ingredients.map((e) => e.toEntity()).toList();
    List<DirectionEntity> directionEntityList =
        directions.map((e) => e.toEntity()).toList();
    return RecipeEntity(
      id,
      title,
      numberOfServings,
      photoUrl,
      ingredientEntityList,
      directionEntityList,
      tags,
    );
  }

  factory Recipe.fromEntity(RecipeEntity entity) {
    List<Ingredient> ingredientList =
        entity.ingredients.map((e) => Ingredient.fromEntity(e)).toList();
    List<Direction> directionList =
        entity.directions.map((e) => Direction.fromEntity(e)).toList();

    return Recipe(
      entity.title,
      entity.numberOfServings,
      id: entity.id,
      photoUrl: entity.photoUrl,
      ingredients: ingredientList,
      directions: directionList,
      tags: entity.tags,
    );
  }
}

class Ingredient extends Equatable {
  final String foodId;
  final String quantity;
  final String servingId;

  Ingredient(this.foodId, this.quantity, this.servingId);

  @override
  List<Object> get props => [foodId, quantity, servingId];

  IngredientEntity toEntity() {
    return IngredientEntity(foodId, quantity, servingId);
  }

  factory Ingredient.fromEntity(IngredientEntity entity) {
    return Ingredient(entity.foodId, entity.quantity, entity.servingId);
  }

  @override
  String toString() {
    return "Ingredient ${toEntity().toJson()}";
  }
}

class Direction extends Equatable {
  final int id;
  final String content;

  Direction(this.id, this.content);

  @override
  List<Object> get props => [id, content];

  DirectionEntity toEntity() {
    return DirectionEntity(id, content);
  }

  factory Direction.fromEntity(DirectionEntity entity) {
    return Direction(entity.id, entity.content);
  }
}
