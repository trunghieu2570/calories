import 'package:calories/entities/entities.dart';
import 'package:calories/util.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class Food extends Equatable {
  final String id;
  final String creatorId;
  final bool share;
  final String name;
  final String brand;
  final String photoUrl;
  final Serving servings;
  final NutritionInfo nutritionInfo;
  final List<String> tags;

  Food(this.name,
      {this.brand,
      this.creatorId,
      this.share,
      this.photoUrl,
      this.servings,
      this.nutritionInfo,
      this.id,
      this.tags});

  @override
  List<Object> get props => [
        id,
        name,
        creatorId,
        share,
        brand,
        photoUrl,
        servings,
        nutritionInfo,
        tags
      ];

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
      creatorId: entity.creatorId,
      share: entity.share,
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
      String creatorId,
      bool share,
      String brand,
      String photoUrl,
      Serving servings,
      NutritionInfo nutritionInfo,
      String id,
      List<String> tags}) {
    return Food(
      name ?? this.name,
      creatorId: creatorId ?? this.creatorId,
      share: share ?? this.share,
      brand: brand ?? this.brand,
      servings: servings ?? this.servings,
      tags: tags ?? this.tags,
      photoUrl: photoUrl ?? this.photoUrl,
      id: id ?? this.id,
      nutritionInfo: nutritionInfo ?? this.nutritionInfo,
    );
  }

  FoodEntity toEntity() {
    return FoodEntity(id, name, creatorId, share, brand, photoUrl,
        servings.toEntity(), nutritionInfo.toEntity(), tags);
  }

  @override
  String toString() {
    return "FoodEntity ${toEntity().toJson()}";
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

  NutritionInfo operator +(NutritionInfo other) {
    try {
      return NutritionInfo(
        protein: add2StringAsDouble(this.protein, other.protein),
        carbohydrates:
            add2StringAsDouble(this.carbohydrates, other.carbohydrates),
        fats: add2StringAsDouble(this.fats, other.fats),
        fiber: add2StringAsDouble(this.fiber, other.fiber),
        calories: add2StringAsDouble(this.calories, other.calories),
        cholesterol: add2StringAsDouble(this.cholesterol, other.cholesterol),
        sugars: add2StringAsDouble(this.sugars, other.sugars),
        sodium: add2StringAsDouble(this.sodium, other.sodium),
        saturatedFats:
            add2StringAsDouble(this.saturatedFats, other.saturatedFats),
      );
    } catch (_) {
      return NutritionInfo.empty();
    }
  }

  factory NutritionInfo.empty() {
    return NutritionInfo(
      calories: "0",
      protein: "0",
      fats: "0",
      carbohydrates: "0",
      saturatedFats: "0",
      sodium: "0",
      sugars: "0",
      fiber: "0",
      cholesterol: "0",
    );
  }

  @override
  String toString() {
    return "NutritionInfo ${toEntity().toJson()}";
  }
}
