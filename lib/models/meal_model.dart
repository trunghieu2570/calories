import 'package:calories/entities/entities.dart';
import 'package:equatable/equatable.dart';

import 'food_model.dart';
import 'recipe_model.dart';

class MealItemType {
  static const String FOOD = 'food';
  static const String RECIPE = 'recipe';
}

class Meal extends Equatable {
  final String id;
  final String name;
  final String creatorId;
  final bool share;
  final String photoUrl;
  final List<MealItem> items;
  final List<String> tags;

  Meal(this.name,
      {this.id,
      this.creatorId,
      this.share,
      this.photoUrl,
      this.items,
      this.tags});

  MealEntity toEntity() {
    final List<MealItemEntity> entityItems =
        items.map((e) => e.toEntity()).toList();
    return MealEntity(id, name, creatorId, share, photoUrl, entityItems, tags);
  }

  factory Meal.fromEntity(MealEntity entity) {
    final List<MealItem> mItems =
        entity.items.map((e) => MealItem.fromEntity(e)).toList();
    return Meal(
      entity.name,
      id: entity.id,
      creatorId: entity.creatorId,
      share: entity.share,
      photoUrl: entity.photoUrl,
      items: mItems,
      tags: entity.tags,
    );
  }

  Meal copyWith(
      {String id,
      String name,
      String creatorId,
      bool share,
      String photoUrl,
      List<String> tags,
      List<MealItem> items}) {
    return Meal(
      name ?? this.name,
      id: id ?? this.id,
      creatorId: creatorId ?? this.creatorId,
      share: share ?? this.share,
      tags: tags ?? this.tags,
      photoUrl: photoUrl ?? this.photoUrl,
      items: items ?? this.items,
    );
  }

  @override
  String toString() {
    return "Meal ${toEntity().toJson()}";
  }

  NutritionInfo getSummaryNutrition(
    final List<Food> foods,
    final List<Recipe> recipes,
  ) {
    if (items == null) return NutritionInfo.empty();
    var sum = NutritionInfo.empty();
    for (final item in items) {
      try {
        if (item.type == MealItemType.FOOD) {
          final food = foods.firstWhere((e) => e.id == item.itemId);
          sum += food.nutritionInfo;
        } else if (item.type == MealItemType.RECIPE) {
          final recipe = recipes.firstWhere((e) => e.id == item.itemId);
          sum += recipe.getSummaryNutrition(foods);
        }
      } catch (err) {
        print(err);
      }
    }
    return sum;
  }

  @override
  List<Object> get props => [id, name, creatorId, share, photoUrl, name, tags];
}

class MealItem extends Equatable {
  final String itemId;
  final String type;
  final String quantity;

  MealItem(this.itemId, this.type, this.quantity);

  MealItemEntity toEntity() {
    return MealItemEntity(itemId, type, quantity);
  }

  factory MealItem.fromEntity(MealItemEntity entity) {
    return MealItem(entity.itemId, entity.type, entity.quantity);
  }

  @override
  List<Object> get props => [itemId, type, quantity];

  @override
  String toString() {
    return "MealItem ${toEntity().toJson()}";
  }
}
