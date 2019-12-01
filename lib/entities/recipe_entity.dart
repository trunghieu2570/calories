import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class RecipeEntity extends Equatable {
  final String id;
  final String title;
  final int numberOfServings;
  final String photoUrl;
  final List<IngredientEntity> ingredients;
  final List<DirectionEntity> directions;
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
    var directionsJson = map["directions"] as List;
    var tagsJson = map["tags"] as List;
    List<IngredientEntity> ingredientsList = ingredientsJson
        .map((ingredient) =>
            IngredientEntity.fromJson(Map<String, Object>.from(ingredient)))
        .toList();
    List<DirectionEntity> directionsList = directionsJson
        .map((direction) =>
            DirectionEntity.fromJson(Map<String, Object>.from(direction)))
        .toList();
    List<String> tagsList = List<String>.from(tagsJson);

    return RecipeEntity(
      map["id"] as String,
      map["title"] as String,
      map["numberOfServings"] as int,
      map["photoUrl"] as String,
      ingredientsList,
      directionsList,
      tagsList,
    );
  }

  factory RecipeEntity.fromSnapshot(DocumentSnapshot snapshot) {
    var ingredientsJson = snapshot.data["ingredients"] as List;
    var directionsJson = snapshot.data["directions"] as List;
    var tagsJson = snapshot.data["tags"] as List;
    List<IngredientEntity> ingredientsList = ingredientsJson
        .map((ingredient) =>
            IngredientEntity.fromJson(Map<String, Object>.from(ingredient)))
        .toList();
    List<DirectionEntity> directionsList = directionsJson
        .map((direction) =>
            DirectionEntity.fromJson(Map<String, Object>.from(direction)))
        .toList();
    List<String> tagsList = List<String>.from(tagsJson);

    return RecipeEntity(
      snapshot.data["id"],
      snapshot.data["title"],
      snapshot.data["numberOfServings"],
      snapshot.data["photoUrl"],
      ingredientsList,
      directionsList,
      tagsList,
    );
  }

  Map<String, Object> toDocument() {
    return {
      'title': title,
      'numberOfServings': numberOfServings,
      'urlPhoto': photoUrl,
      'ingredients': json.encode(ingredients),
      'directions': json.encode(directions),
      'tags': json.encode(tags),
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
  final String servingId;

  IngredientEntity(this.foodId, this.quantity, this.servingId);

  @override
  List<Object> get props => [foodId, quantity, servingId];

  Map<String, Object> toJson() {
    return {
      'foodId': foodId,
      'quantity': quantity,
      'servingId': servingId,
    };
  }

  factory IngredientEntity.fromJson(Map<String, Object> json) {
    return IngredientEntity(
      json["foodId"] as String,
      json["quantity"] as String,
      json["servingId"] as String,
    );
  }

  factory IngredientEntity.fromSnapshot(DocumentSnapshot snapshot) {
    return IngredientEntity(
      snapshot.data["foodId"],
      snapshot.data["quantity"],
      snapshot.data["servingId"],
    );
  }

  Map<String, Object> toDocument() {
    return {
      'foodId': foodId,
      'quantity': quantity,
      'servingId': servingId,
    };
  }

  @override
  String toString() {
    return "IngredientEntity ${toJson()}";
  }
}

class DirectionEntity extends Equatable {
  final int id;
  final String content;

  DirectionEntity(this.id, this.content);

  @override
  List<Object> get props => [id, content];

  Map<String, Object> toJson() {
    return {
      'id': id,
      'content': content,
    };
  }

  factory DirectionEntity.fromJson(Map<String, Object> json) {
    return DirectionEntity(
      json["id"] as int,
      json["content"] as String,
    );
  }

  factory DirectionEntity.fromSnapshot(DocumentSnapshot snapshot) {
    return DirectionEntity(
      snapshot.data["id"],
      snapshot.data["content"],
    );
  }

  Map<String, Object> toDocument() {
    return {
      'id': id,
      'content': content,
    };
  }

  @override
  String toString() {
    return "DirectionEntity ${toJson()}";
  }
}
