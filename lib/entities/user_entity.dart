import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String fullName;
  final String photoUrl;
  final String email;
  final DateTime birthday;
  final int height;
  final int weight;
  final int gender;
  final List<String> favoriteFoods;
  final List<String> favoriteRecipes;
  final List<String> favoriteMeals;

  UserEntity(
      this.uid,
      this.fullName,
      this.photoUrl,
      this.email,
      this.birthday,
      this.height,
      this.weight,
      this.gender,
      this.favoriteFoods,
      this.favoriteRecipes,
      this.favoriteMeals);

  @override
  List<Object> get props => [
        uid,
        fullName,
        photoUrl,
        email,
        birthday,
        height,
        weight,
        gender,
        favoriteFoods,
        favoriteRecipes,
        favoriteMeals
      ];

  factory UserEntity.fromJson(Map<String, Object> map) {
    return UserEntity(
        map["uid"] as String,
        map["fullName"] as String,
        map["photoUrl"] as String,
        map["email"] as String,
        (map["birthday"] as Timestamp).toDate(),
        map["height"] as int,
        map["weight"] as int,
        map["gender"] as int,
        map["favoriteFoods"] as List<String>,
        map["favoriteRecipes"] as List<String>,
        map["favoriteMeals"] as List<String>);
  }

  Map<String, Object> toJson() {
    return {
      'uid': uid,
      'fullName': fullName,
      'photoUrl': photoUrl,
      'email': email,
      'birthday': birthday,
      'height': height,
      'weight': weight,
      'gender': gender,
      'favoriteFoods': json.encode(favoriteFoods),
      'favoriteRecipes': json.encode(favoriteRecipes),
      'favoriteMeals': json.encode(favoriteMeals),
    };
  }

  factory UserEntity.fromSnapshot(DocumentSnapshot snapshot) {
    return UserEntity(
      snapshot.documentID,
      snapshot.data["fullName"],
      snapshot.data["photoUrl"],
      snapshot.data["email"],
      (snapshot.data["birthday"] as Timestamp).toDate(),
      snapshot.data["height"],
      snapshot.data["weight"],
      snapshot.data["gender"],
      snapshot.data["favoriteFoods"] == null
          ? null
          : List<String>.from(snapshot.data["favoriteFoods"]),
      snapshot.data["favoriteRecipes"] == null
          ? null
          : List<String>.from(snapshot.data["favoriteRecipes"]),
      snapshot.data["favoriteMeals"] == null
          ? null
          : List<String>.from(snapshot.data["favoriteMeals"]),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'fullName': fullName,
      'photoUrl': photoUrl,
      'email': email,
      'birthday': birthday,
      'height': height,
      'weight': weight,
      'gender': gender,
      'favoriteFoods': favoriteFoods,
      'favoriteRecipes': favoriteRecipes,
      'favoriteMeals': favoriteMeals,
    };
  }

  @override
  String toString() {
    return "UserEntity ${toJson()}";
  }
}
