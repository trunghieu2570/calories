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
  final List<String> tags;

  Meal(this.name, {this.id, this.photoUrl, this.items, this.tags});

  MealEntity toEntity() {
    final List<MealItemEntity> entityItems =
        items.map((e) => e.toEntity()).toList();
    return MealEntity(id, name, photoUrl, entityItems, tags);
  }

  factory Meal.fromEntity(MealEntity entity) {
    final List<MealItem> mItems =
        entity.items.map((e) => MealItem.fromEntity(e)).toList();
    return Meal(
      entity.name,
      id: entity.id,
      photoUrl: entity.photoUrl,
      items: mItems,
      tags: entity.tags,
    );
  }

  Meal copyWith(
      {String id,
      String photoUrl,
      String name,
      List<String> tags,
      List<MealItem> items}) {
    return Meal(
      name ?? this.name,
      id: id ?? this.id,
      tags: tags ?? this.tags,
      photoUrl: photoUrl ?? this.photoUrl,
      items: items ?? this.items,
    );
  }

  @override
  String toString() {
    return "Meal ${toEntity().toJson()}";
  }

  @override
  List<Object> get props => [id, name, photoUrl, name, tags];
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
