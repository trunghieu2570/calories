import 'package:equatable/equatable.dart';

abstract class FavoriteFoodsEvent extends Equatable {
  const FavoriteFoodsEvent();

  @override
  List<Object> get props => [];
}

class AddFavoriteFood extends FavoriteFoodsEvent {
  final String foodId;
  final String userId;

  const AddFavoriteFood(this.userId, this.foodId);

  @override
  List<Object> get props => [userId, foodId];

  @override
  String toString() {
    return "Add favorite food $foodId to $userId";
  }
}

class DeleteFavoriteFood extends FavoriteFoodsEvent {
  final String foodId;
  final String userId;

  const DeleteFavoriteFood(this.userId, this.foodId);

  @override
  List<Object> get props => [userId, foodId];

  @override
  String toString() {
    return "Delete favorite food $foodId from $userId";
  }
}

class FavoriteFoodsUpdated extends FavoriteFoodsEvent {
  final List<String> favoriteFoods;

  const FavoriteFoodsUpdated(this.favoriteFoods);

  @override
  List<Object> get props => [favoriteFoods];
}

class LoadFavoriteFoods extends FavoriteFoodsEvent {
  final String userId;
  const LoadFavoriteFoods(this.userId);
  @override
  List<Object> get props => [userId];
}
