import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'meal_entity.dart';

class DailyMealEntity extends Equatable {
  final String id;
  final String section;
  final String date;
  final List<MealItemEntity> items;

  DailyMealEntity(this.id, this.section, this.date, this.items);

  @override
  List<Object> get props => [id, section, date, items];

  Map<String, Object> toJson() {
    return {
      'id': id,
      'section': section,
      'date': date,
      'items': json.encode(items),
    };
  }

  factory DailyMealEntity.fromJson(Map<String, Object> map) {
    var itemList = map['items'] as List;
    final List<MealItemEntity> items = itemList
        .map((e) => MealItemEntity.fromJson(Map<String, Object>.from(e)))
        .toList();
    return DailyMealEntity(
      map['id'] as String,
      map['section'] as String,
      map['date'] as String,
      items,
    );
  }

  factory DailyMealEntity.fromSnapshot(DocumentSnapshot snapshot) {
    var itemList = List<Map<dynamic, dynamic>>.from(snapshot.data['items']);
    final List<MealItemEntity> items = itemList
        .map((e) => MealItemEntity.fromJson(Map<String, Object>.from(e)))
        .toList();
    return DailyMealEntity(
      snapshot.documentID,
      snapshot.data['section'],
      snapshot.data['date'],
      items,
    );
  }

  Map<String, Object> toDocument() {
    var listItems = items.map((e) => e.toDocument()).toList();
    return {
      'section': section,
      'date': date,
      'items': listItems,
    };
  }

  @override
  String toString() {
    return "DialyMealEntity ${toJson()}";
  }
}