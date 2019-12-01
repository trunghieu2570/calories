import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class FoodEntity extends Equatable {
  final String id;
  final String name;
  final String brand;
  final String photoUrl;
  final ServingEntity servings;
  final NutritionInfoEntity nutritionInfo;
  final List<String> tags;

  FoodEntity(this.id, this.name, this.brand, this.photoUrl, this.servings,
      this.nutritionInfo, this.tags);

  @override
  List<Object> get props =>
      [id, name, brand, photoUrl, servings, nutritionInfo, tags];

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'photoUrl': photoUrl,
      'servings': json.encode(servings),
      'nutritionInfo': json.encode(nutritionInfo),
      'tags': json.encode(tags),
    };
  }

  factory FoodEntity.fromJson(Map<String, Object> map) {
    //var tags = map["tags"];
    //List<String> tagsList = List<String>.from(tags);
    return FoodEntity(
      map["id"] as String,
      map["name"] as String,
      map["brand"] as String,
      map["photoUrl"] as String,
      json.decode(map["servings"] as String),
      json.decode(map["nutritionInfo"] as String),
      map["tags"],
    );
  }

  factory FoodEntity.fromSnapshot(DocumentSnapshot snapshot) {
    //List<String> tagsList = List<String>.from();
    return FoodEntity(
      snapshot.documentID,
      snapshot.data["name"],
      snapshot.data["brand"],
      snapshot.data["photoUrl"],
      ServingEntity.fromJson(
          Map<String, Object>.from(snapshot.data["servings"])),
      NutritionInfoEntity.fromJson(
          Map<String, Object>.from(snapshot.data["nutritionInfo"])),
      snapshot.data["tags"],
    );
  }

  Map<String, Object> toDocument() {
    return {
      'name': name,
      'brand': brand,
      'photoUrl': photoUrl,
      'servings': servings.toDocument(),
      'nutritionInfo': nutritionInfo.toDocument(),
      'tags': tags,
    };
  }

  @override
  String toString() {
    return "FoodEntity ${toJson()}";
  }
}

class ServingEntity extends Equatable {
  final String unit;
  final String quantity;

  ServingEntity(this.unit, this.quantity);

  @override
  List<Object> get props => [unit, quantity];

  Map<String, Object> toJson() {
    return {
      'unit': unit,
      'quantity': quantity,
    };
  }

  factory ServingEntity.fromJson(Map<String, Object> json) {
    return ServingEntity(
      json["unit"] as String,
      json["quantity"] as String,
    );
  }

  factory ServingEntity.fromSnapshot(DocumentSnapshot snapshot) {
    return ServingEntity(
      snapshot.data["unit"],
      snapshot.data["quantity"],
    );
  }

  Map<String, Object> toDocument() {
    return {
      'unit': unit,
      'quantity': quantity,
    };
  }

  @override
  String toString() {
    return "ServingEntity ${toJson()}";
  }
}

class NutritionInfoEntity extends Equatable {
  final String calories; //kcal
  final String fats; //g
  final String carbohydrates; //g
  final String protein; //g
  final String saturatedFats; //g
  final String sodium; //mg
  final String fiber; //g
  final String sugars; //g
  final String cholesterol; //mg

  NutritionInfoEntity(
      this.calories,
      this.fats,
      this.carbohydrates,
      this.protein,
      this.saturatedFats,
      this.sodium,
      this.fiber,
      this.sugars,
      this.cholesterol);

  @override
  List<Object> get props => [
        calories,
        fats,
        carbohydrates,
        protein,
        saturatedFats,
        sodium,
        fiber,
        sugars,
        cholesterol
      ];

  Map<String, Object> toJson() {
    return {
      'calories': calories,
      'fats': fats,
      'carbohydrates': carbohydrates,
      'protein': protein,
      'saturatedFats': saturatedFats,
      'sodium': sodium,
      'fiber': fiber,
      'sugars': sugars,
      'cholesterol': cholesterol,
    };
  }

  static fromJson(Map<String, Object> json) {
    return NutritionInfoEntity(
      json["calories"] as String,
      json["fats"] as String,
      json["carbohydrates"] as String,
      json["protein"] as String,
      json["saturatedFats"] as String,
      json["sodium"] as String,
      json["fiber"] as String,
      json["sugars"] as String,
      json["cholesterol"] as String,
    );
  }

  static fromSnapshot(DocumentSnapshot snapshot) {
    return NutritionInfoEntity(
      snapshot.data["calories"],
      snapshot.data["fats"],
      snapshot.data["carbohydrates"],
      snapshot.data["protein"],
      snapshot.data["saturatedFats"],
      snapshot.data["sodium"],
      snapshot.data["fiber"],
      snapshot.data["sugars"],
      snapshot.data["cholesterol"],
    );
  }

  Map<String, Object> toDocument() {
    return {
      'calories': calories,
      'fats': fats,
      'carbohydrates': carbohydrates,
      'protein': protein,
      'saturatedFats': saturatedFats,
      'sodium': sodium,
      'fiber': fiber,
      'sugars': sugars,
      'cholesterol': cholesterol,
    };
  }

  @override
  String toString() {
    return "NutritionInfoEntity { nutritionInfo: ${toJson()} }";
  }
}
