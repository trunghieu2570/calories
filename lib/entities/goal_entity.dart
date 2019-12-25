import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class GoalEntity extends Equatable {
  final String id;
  final String name;
  final DateTime startDate;
  final List<GoalItemEntity> items;

  GoalEntity(this.id, this.name, this.startDate, this.items);

  @override
  List<Object> get props => [id, name, startDate, items];

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate,
      'items': json.encode(items),
    };
  }

  factory GoalEntity.fromJson(Map<String, Object> map) {
    var itemList = map['items'] as List;
    final List<GoalItemEntity> items = itemList
        .map((e) => GoalItemEntity.fromJson(Map<String, Object>.from(e)))
        .toList();
    return GoalEntity(
      map['id'] as String,
      map['name'] as String,
      (map['startDate'] as Timestamp).toDate(),
      items,
    );
  }

  factory GoalEntity.fromSnapshot(DocumentSnapshot snapshot) {
    var itemList = List<Map<dynamic, dynamic>>.from(snapshot.data['items']);
    final List<GoalItemEntity> items = itemList
        .map((e) => GoalItemEntity.fromJson(Map<String, Object>.from(e)))
        .toList();
    return GoalEntity(
      snapshot.documentID,
      snapshot.data['name'],
      (snapshot.data['startDate'] as Timestamp).toDate(),
      items,
    );
  }

  Map<String, Object> toDocument() {
    var listItems = items.map((e) => e.toDocument()).toList();
    return {
      'name': name,
      'startDate': startDate,
      'items': listItems,
    };
  }

  @override
  String toString() {
    return "GoalEntity ${toJson()}";
  }
}

class GoalItemEntity extends Equatable {
  final String type;
  final String min;
  final String max;

  GoalItemEntity(this.type, this.min, this.max);

  Map<String, Object> toJson() {
    return {
      'type': type,
      'min': min,
      'max': max,
    };
  }

  factory GoalItemEntity.fromJson(Map<String, Object> map) {
    return GoalItemEntity(
      map['type'] as String,
      map['min'] as String,
      map['max'] as String,
    );
  }

  factory GoalItemEntity.fromSnapshot(DocumentSnapshot snapshot) {
    return GoalItemEntity(
      snapshot.data['type'],
      snapshot.data['min'],
      snapshot.data['max'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      'type': type,
      'min': min,
      'max': max,
    };
  }

  @override
  String toString() {
    return "GoalItemEntity ${toJson()}";
  }

  @override
  List<Object> get props => [type, min, max];
}
