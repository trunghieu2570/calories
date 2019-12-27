import 'package:calories/entities/entities.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class User extends Equatable {
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

  User(
      {@required this.uid,
      @required this.fullName,
      @required this.email,
      this.photoUrl,
      this.birthday,
      this.weight,
      this.height,
      this.gender,
      this.favoriteFoods,
      this.favoriteRecipes,
      this.favoriteMeals})
      : assert(uid != null),
        assert(fullName != null),
        assert(email != null);

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
        favoriteMeals,
      ];

  factory User.fromEntity(UserEntity entity) {
    return User(
      uid: entity.uid,
      fullName: entity.fullName,
      email: entity.email,
      photoUrl: entity.photoUrl,
      birthday: entity.birthday,
      height: entity.height,
      weight: entity.weight,
      gender: entity.gender,
      favoriteFoods: entity.favoriteFoods,
      favoriteRecipes: entity.favoriteRecipes,
      favoriteMeals: entity.favoriteMeals,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
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
      favoriteMeals,
    );
  }

  User copyWith(
      {String uid,
      String fullName,
      String email,
      String photoUrl,
      DateTime birthday,
      int weight,
      int height,
      int gender,
      List<String> favoriteFoods,
      List<String> favoriteRecipes,
      List<String> favoriteMeals}) {
    return User(
        uid: uid ?? this.uid,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        birthday: birthday ?? this.birthday,
        photoUrl: photoUrl ?? this.photoUrl,
        height: height ?? this.height,
        weight: weight ?? this.weight,
        gender: gender ?? this.gender,
        favoriteFoods: favoriteFoods ?? this.favoriteFoods,
        favoriteRecipes: favoriteRecipes ?? this.favoriteRecipes,
        favoriteMeals: favoriteMeals ?? this.favoriteMeals);
  }

  @override
  String toString() {
    return "User ${toEntity().toJson()}";
  }

  @override
  int get hashCode =>
      uid.hashCode ^
      fullName.hashCode ^
      email.hashCode ^
      birthday.hashCode ^
      photoUrl.hashCode ^
      height.hashCode ^
      weight.hashCode ^
      gender.hashCode ^
      favoriteFoods.hashCode ^
      favoriteRecipes.hashCode ^
      favoriteMeals.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          other.runtimeType == runtimeType &&
          uid == other.uid &&
          fullName == other.fullName &&
          email == other.email &&
          birthday == other.birthday &&
          photoUrl == other.photoUrl &&
          height == other.height &&
          weight == other.height &&
          gender == other.gender &&
          favoriteFoods == other.favoriteFoods &&
          favoriteRecipes == other.favoriteRecipes &&
          favoriteMeals == other.favoriteMeals;
}
