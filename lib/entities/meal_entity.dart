import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MealEntity extends Equatable {
  final String id;
  final String name;
  final String creatorId;
  final bool share;
  final String photoUrl;
  final List<MealItemEntity> items;
  final List<String> tags;

  MealEntity(this.id, this.name, this.creatorId, this.share, this.photoUrl,
      this.items, this.tags);

  @override
  List<Object> get props => [id, name, creatorId, share, photoUrl, items, tags];

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
      'creatorId': creatorId,
      'share': share,
      'photoUrl': photoUrl,
      'items': json.encode(items),
      'tags': json.encode(tags),
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
      map['creatorId'] as String,
      map['share'] as bool,
      map['photoUrl'] as String,
      items,
      map['tags'],
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
      snapshot.data['creatorId'],
      snapshot.data['share'],
      snapshot.data['photoUrl'],
      items,
      snapshot.data["tags"].cast<String>(),
    );
  }

  Map<String, Object> toDocument() {
    var listItems = items.map((e) => e.toDocument()).toList();
    return {
      'name': name,
      'creatorId': creatorId,
      'share': share,
      'photoUrl': photoUrl,
      'items': listItems,
      'tags': tags,
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
