import 'package:calories/entities/entities.dart';
import 'package:equatable/equatable.dart';

class MealItemType {
  static const String FOOD = 'food';
  static const String RECIPE = 'recipe';
}

class Meal extends Equatable {
  final String id;
  final String name;
  final String photoUrl;
  final List<MealItem> items;

  Meal(this.id, this.name, {this.photoUrl, this.items});

  MealEntity toEntity() {
    final List<MealItemEntity> entityItems =
        items.map((e) => e.toEntity()).toList();
    return MealEntity(id, name, photoUrl, entityItems);
  }

  factory Meal.fromEntity(MealEntity entity) {
    final List<MealItem> mItems =
        entity.items.map((e) => MealItem.fromEntity(e)).toList();
    return Meal(
      entity.id,
      entity.name,
      photoUrl: entity.photoUrl,
      items: mItems,
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [id, name, photoUrl, name];
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
