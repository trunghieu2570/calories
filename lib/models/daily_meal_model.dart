import 'package:calories/entities/entities.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'food_model.dart';
import 'meal_model.dart';
import 'recipe_model.dart';

class DailyMealSection {
  static const String BREAKFAST = "Breakfast";
  static const String LUNCH = "Lunch";
  static const String DINNER = "Dinner";
  static const String SNACK = "Snack";
}

class DailyMeal extends Equatable {
  final String id;
  final String section;
  final String date;
  final List<MealItem> items;

  DailyMeal({@required this.section, @required this.date, this.id, this.items})
      : assert(section != null),
        assert(date != null);

  DailyMealEntity toEntity() {
    final List<MealItemEntity> entityItems =
        items.map((e) => e.toEntity()).toList();
    return DailyMealEntity(id, section, date, entityItems);
  }

  factory DailyMeal.fromEntity(DailyMealEntity entity) {
    final List<MealItem> mItems =
        entity.items.map((e) => MealItem.fromEntity(e)).toList();
    return DailyMeal(
      id: entity.id,
      section: entity.section,
      date: entity.date,
      items: mItems,
    );
  }

  DailyMeal copyWith(
      {String id, String section, String date, List<MealItem> items}) {
    return DailyMeal(
      id: id ?? this.id,
      section: section ?? this.section,
      date: date ?? this.date,
      items: items ?? this.items,
    );
  }

  @override
  String toString() {
    return "DialyMeal ${toEntity().toJson()}";
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
  List<Object> get props => [id, section, date, items];
}
