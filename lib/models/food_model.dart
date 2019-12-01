import 'package:calories/entities/entities.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class Food extends Equatable {
  final String id;
  final String name;
  final String brand;
  final String photoUrl;
  final Serving servings;
  final NutritionInfo nutritionInfo;
  final List<String> tags;

  Food(this.name,
      {this.brand = '',
      this.photoUrl,
      this.servings,
      this.nutritionInfo,
      this.id,
      this.tags});

  @override
  List<Object> get props =>
      [id, name, brand, photoUrl, servings, nutritionInfo, tags];

/*  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'photoUrl': photoUrl,
      'servings': json.encode(servings),
      'nutritionInfo': json.encode(nutritionInfo),
      'tags': json.encode(tags),
    };
  }*/

  factory Food.fromEntity(FoodEntity entity) {
    return Food(
      entity.name,
      photoUrl: entity.photoUrl,
      brand: entity.brand,
      nutritionInfo: NutritionInfo.fromEntity(entity.nutritionInfo),
      tags: entity.tags,
      id: entity.id,
      servings: Serving.fromEntity(entity.servings),
    );
  }

  Food copyWith(
      {String name,
      String brand,
      String photoUrl,
      Serving servings,
      NutritionInfo nutritionInfo,
      String id,
      List<String> tags}) {
    return Food(
      name ?? this.name,
      brand: brand ?? this.brand,
      servings: servings ?? this.servings,
      tags: tags ?? this.tags,
      photoUrl: photoUrl ?? this.photoUrl,
      id: id ?? this.id,
      nutritionInfo: nutritionInfo ?? this.nutritionInfo,
    );
  }

  FoodEntity toEntity() {
    return FoodEntity(id, name, brand, photoUrl, servings.toEntity(),
        nutritionInfo.toEntity(), tags);
  }

  @override
  String toString() {
    return "FoodEntity { foodEntity: ${toEntity().toJson()} }";
  }
}

class Serving extends Equatable {
  final String unit;
  final String quantity;

  Serving(this.unit, this.quantity);

  @override
  List<Object> get props => [unit, quantity];

  factory Serving.fromEntity(ServingEntity entity) {
    return Serving(entity.unit, entity.quantity);
  }

  ServingEntity toEntity() {
    return ServingEntity(unit, quantity);
  }

  @override
  String toString() {
    return "Serving ${toEntity().toJson()}";
  }
}

class NutritionInfo extends Equatable {
  final String calories; //kcal
  final String fats; //g
  final String carbohydrates; //g
  final String protein; //g
  final String saturatedFats; //g
  final String sodium; //mg
  final String fiber; //g
  final String sugars; //g
  final String cholesterol; //mg

  NutritionInfo(
      {@required this.calories,
      @required this.fats,
      @required this.carbohydrates,
      @required this.protein,
      this.saturatedFats,
      this.sodium,
      this.fiber,
      this.sugars,
      this.cholesterol})
      : assert(calories != null),
        assert(fats != null),
        assert(carbohydrates != null),
        assert(protein != null);

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

  NutritionInfoEntity toEntity() {
    return NutritionInfoEntity(calories, fats, carbohydrates, protein,
        saturatedFats, sodium, fiber, sugars, cholesterol);
  }

  factory NutritionInfo.fromEntity(NutritionInfoEntity entity) {
    return NutritionInfo(
      calories: entity.calories,
      protein: entity.protein,
      fats: entity.fats,
      carbohydrates: entity.carbohydrates,
      saturatedFats: entity.saturatedFats,
      sodium: entity.sodium,
      sugars: entity.sugars,
      fiber: entity.fiber,
      cholesterol: entity.cholesterol,
    );
  }

  @override
  String toString() {
    return "NutritionInfo ${toEntity().toJson()}";
  }
}
