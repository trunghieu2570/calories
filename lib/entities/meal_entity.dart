import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';



class MealEntity extends Equatable {
  final String id;
  final String name;
  final String photoUrl;
  final List<MealItemEntity> items;

  MealEntity(this.id, this.name, this.photoUrl, this.items);

  @override
  List<Object> get props => [id, name, photoUrl, items];

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
      'photoUrl': photoUrl,
      'items': json.encode(items),
    };
  }

  factory MealEntity.fromJson(Map<String, Object> map) {
    var itemList = map['items'] as List;
    final List<MealItemEntity> items = itemList
        .map((e) => MealItemEntity.fromJson(Map<String, Object>.from(e)))
        .toList();
    return MealEntity(
      map['id'] as String,
      map['name'] as String,
      map['photoUrl'] as String,
      items,
    );
  }

  factory MealEntity.fromSnapshot(DocumentSnapshot snapshot) {
    var itemList = List<Map<dynamic, dynamic>>.from(snapshot.data['items']);
    final List<MealItemEntity> items = itemList
        .map((e) => MealItemEntity.fromJson(Map<String, Object>.from(e)))
        .toList();
    return MealEntity(
      snapshot.documentID,
      snapshot.data['name'],
      snapshot.data['photoUrl'],
      items,
    );
  }

  Map<String, Object> toDocument() {
    return {
      'name': name,
      'photoUrl': photoUrl,
      'items': json.encode(items),
    };
  }

   @override
  String toString() {
    return "MealEntity ${toJson()}";
  }
}

class MealItemEntity extends Equatable {
  final String itemId;
  final String type;
  final String quantity;

  MealItemEntity(this.itemId, this.type, this.quantity);

  Map<String, Object> toJson() {
    return {
      'itemId': itemId,
      'type': type,
      'quantity': quantity,
    };
  }

  factory MealItemEntity.fromJson(Map<String, Object> map) {
    return MealItemEntity(
      map['itemId'] as String,
      map['type'] as String,
      map['quantity'] as String,
    );
  }

  factory MealItemEntity.fromSnapshot(DocumentSnapshot snapshot) {
    return MealItemEntity(
      snapshot.data['itemId'],
      snapshot.data['type'],
      snapshot.data['quantity'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      'itemId': itemId,
      'type': type,
      'quantity': quantity,
    };
  }

  @override
  String toString() {
    return "MealItemEntity ${toJson()}";
  }

  @override
  List<Object> get props => [itemId, type, quantity];
}
