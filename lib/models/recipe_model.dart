import 'package:calories/entities/entities.dart';
import 'package:calories/models/food_model.dart';
import 'package:equatable/equatable.dart';

class Recipe extends Equatable {
  final String id;
  final String title;
  final String creatorId;
  final bool share;
  final int numberOfServings;
  final String photoUrl;
  final List<Ingredient> ingredients;
  final List<String> directions;
  final List<String> tags;

  Recipe(this.title, this.numberOfServings,
      {this.creatorId,
      this.share,
      this.id,
      this.photoUrl,
      this.ingredients,
      this.directions,
      this.tags});

  @override
  List<Object> get props => [
        id,
        title,
        creatorId,
        share,
        numberOfServings,
        photoUrl,
        ingredients,
        tags
      ];

  RecipeEntity toEntity() {
    List<IngredientEntity> ingredientEntityList =
        ingredients.map((e) => e.toEntity()).toList();
    return RecipeEntity(
      id,
      title,
      creatorId,
      share,
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
      creatorId: entity.creatorId,
      share: entity.share,
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
      String creatorId,
      bool share,
      String id,
      String photoUrl,
      List<Ingredient> ingredients,
      List<String> directions,
      List<String> tags}) {
    return Recipe(
      title ?? this.title,
      numberOfServings ?? this.numberOfServings,
      creatorId: creatorId ?? this.creatorId,
      share: share ?? this.share,
      photoUrl: photoUrl ?? this.photoUrl,
      ingredients: ingredients ?? this.ingredients,
      id: id ?? this.id,
      tags: tags ?? this.tags,
      directions: directions ?? this.directions,
    );
  }

  NutritionInfo getSummaryNutrition(final List<Food> foods) {
    if (ingredients == null) return NutritionInfo.empty();
    var sum = NutritionInfo.empty();
    for (final ingredient in ingredients) {
      var q = 0;
      q = num.tryParse(ingredient.quantity);
      if(q == null) q = 0;
      try {
        final food = foods.firstWhere((e) => e.id == ingredient.foodId);
        sum += (food.nutritionInfo * q);
      } catch (err) {
        print(err);
      }
    }
    return sum;
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
