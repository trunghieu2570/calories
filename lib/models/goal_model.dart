import 'package:calories/entities/entities.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class GoalItemType {
  static const String CALORIES = 'calories';
  static const String PROTEIN = 'protein';
  static const String LIPID = 'lipid';
  static const String CARBOHYDRATE = 'carbohydrate';
  static const String WATER = 'water';
}

class Goal extends Equatable implements Comparable<Goal> {
  final String id;
  final String name;
  final DateTime startDate;
  final List<GoalItem> items;

  Goal({@required this.startDate, this.id, this.name, this.items});

  GoalEntity toEntity() {
    final List<GoalItemEntity> entityItems =
        items.map((e) => e.toEntity()).toList();
    return GoalEntity(id, name, startDate, entityItems);
  }

  factory Goal.fromEntity(GoalEntity entity) {
    final List<GoalItem> mItems =
        entity.items.map((e) => GoalItem.fromEntity(e)).toList();
    return Goal(
      id: entity.id,
      name: entity.name,
      startDate: entity.startDate,
      items: mItems,
    );
  }

  Goal copyWith(
      {String id, String name, DateTime startDate, List<GoalItem> items}) {
    return Goal(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      items: items ?? this.items,
    );
  }

  @override
  String toString() {
    return "Goal ${toEntity().toJson()}";
  }

  @override
  List<Object> get props => [id, name, startDate, items];

  @override
  int compareTo(Goal other) {
    if (this.startDate.isBefore(other.startDate)) return -1;
    if (this.startDate.isAfter(other.startDate)) return 1;
    return 0;
  }
}

class GoalItem extends Equatable {
  final String type;
  final String min;
  final String max;

  GoalItem(this.type, this.min, this.max);

  GoalItemEntity toEntity() {
    return GoalItemEntity(type, min, max);
  }

  factory GoalItem.fromEntity(GoalItemEntity entity) {
    return GoalItem(entity.type, entity.min, entity.max);
  }

  @override
  List<Object> get props => [type, min, max];

  @override
  String toString() {
    return "GoalItem ${toEntity().toJson()}";
  }
}
