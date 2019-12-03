import 'package:calories/entities/entities.dart';
import 'package:equatable/equatable.dart';

class Recipe extends Equatable {
  final String id;
  final String title;
  final int numberOfServings;
  final String photoUrl;
  final List<Ingredient> ingredients;
  final List<String> directions;
  final List<String> tags;

  Recipe(this.title, this.numberOfServings,
      {this.id, this.photoUrl, this.ingredients, this.directions, this.tags});

  @override
  List<Object> get props =>
      [id, title, numberOfServings, photoUrl, ingredients, tags];

  RecipeEntity toEntity() {
    List<IngredientEntity> ingredientEntityList =
        ingredients.map((e) => e.toEntity()).toList();
    return RecipeEntity(
      id,
      title,
      numberOfServings,
      photoUrl,
      ingredientEntityList,
      directions,
      tags,
    );
  }

  factory Recipe.fromEntity(RecipeEntity entity) {
    List<Ingredient> ingredientList =
        entity.ingredients.map((e) => Ingredient.fromEntity(e)).toList();
    return Recipe(
      entity.title,
      entity.numberOfServings,
      id: entity.id,
      photoUrl: entity.photoUrl,
      ingredients: ingredientList,
      directions: entity.directions,
      tags: entity.tags,
    );
  }

  Recipe copyWith(
      {String title,
      int numberOfServings,
      String id,
      String photoUrl,
      List<Ingredient> ingredients,
      List<String> directions,
      List<String> tags}) {
    return Recipe(
      title ?? this.title,
      numberOfServings ?? this.numberOfServings,
      photoUrl: photoUrl ?? this.photoUrl,
      ingredients: ingredients ?? this.ingredients,
      id: id ?? this.id,
      tags: tags ?? this.tags,
      directions: directions ?? this.directions,
    );
  }

  @override
  String toString() {
    return "Recipe ${toEntity().toJson()}";
  }
}

class Ingredient extends Equatable {
  final String foodId;
  final String quantity;

  Ingredient(this.foodId, this.quantity);

  @override
  List<Object> get props => [foodId, quantity];

  IngredientEntity toEntity() {
    return IngredientEntity(foodId, quantity);
  }

  factory Ingredient.fromEntity(IngredientEntity entity) {
    return Ingredient(entity.foodId, entity.quantity);
  }

  @override
  String toString() {
    return "Ingredient ${toEntity().toJson()}";
  }
}
