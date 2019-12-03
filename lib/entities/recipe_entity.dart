import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class RecipeEntity extends Equatable {
  final String id;
  final String title;
  final int numberOfServings;
  final String photoUrl;
  final List<IngredientEntity> ingredients;
  final List<String> directions;
  final List<String> tags;

  RecipeEntity(this.id, this.title, this.numberOfServings, this.photoUrl,
      this.ingredients, this.directions, this.tags);

  @override
  List<Object> get props =>
      [id, title, numberOfServings, photoUrl, ingredients, tags];

  Map<String, Object> toJson() {
    return {
      'id': id,
      'title': title,
      'numberOfServings': numberOfServings,
      'urlPhoto': photoUrl,
      'ingredients': json.encode(ingredients),
      'directions': json.encode(directions),
      'tags': json.encode(tags),
    };
  }

  factory RecipeEntity.fromJson(Map<String, Object> map) {
    var ingredientsJson = map["ingredients"] as List;
    List<IngredientEntity> ingredientsList = ingredientsJson
        .map((ingredient) =>
            IngredientEntity.fromJson(Map<String, Object>.from(ingredient)))
        .toList();
    return RecipeEntity(
      map["id"] as String,
      map["title"] as String,
      map["numberOfServings"] as int,
      map["photoUrl"] as String,
      ingredientsList,
      map["directions"] as List<String>,
      map["tags"] as List<String>,
    );
  }

  factory RecipeEntity.fromSnapshot(DocumentSnapshot snapshot) {
    var ingredients =
        List<Map<dynamic, dynamic>>.from(snapshot.data["ingredients"]);
    List<IngredientEntity> ingredientsList = ingredients
        .map((ingredient) =>
            IngredientEntity.fromJson(Map<String, Object>.from(ingredient)))
        .toList();
    return RecipeEntity(
      snapshot.documentID,
      snapshot.data["title"],
      snapshot.data["numberOfServings"],
      snapshot.data["photoUrl"],
      ingredientsList,
      snapshot.data["directions"].cast<String>(),
      snapshot.data["tags"].cast<String>(),
    );
  }

  Map<String, Object> toDocument() {
    var list = ingredients.map((e) => e.toDocument()).toList();
    return {
      'title': title,
      'numberOfServings': numberOfServings,
      'urlPhoto': photoUrl,
      'ingredients': list,
      'directions': directions,
      'tags': tags,
    };
  }

  @override
  String toString() {
    return "RecipeEntity ${toDocument()}";
  }
}

class IngredientEntity extends Equatable {
  final String foodId;
  final String quantity;

  IngredientEntity(this.foodId, this.quantity);

  @override
  List<Object> get props => [foodId, quantity];

  Map<String, Object> toJson() {
    return {
      'foodId': foodId,
      'quantity': quantity,
    };
  }

  factory IngredientEntity.fromJson(Map<String, Object> json) {
    return IngredientEntity(
      json["foodId"] as String,
      json["quantity"] as String,
    );
  }

  factory IngredientEntity.fromSnapshot(DocumentSnapshot snapshot) {
    return IngredientEntity(
      snapshot.data["foodId"],
      snapshot.data["quantity"],
    );
  }

  Map<String, Object> toDocument() {
    return {
      'foodId': foodId,
      'quantity': quantity,
    };
  }

  @override
  String toString() {
    return "IngredientEntity ${toJson()}";
  }
}
