import 'package:equatable/equatable.dart';

abstract class FavoriteFoodsEvent extends Equatable {
  const FavoriteFoodsEvent();

  @override
  List<Object> get props => [];
}

class AddFavoriteFood extends FavoriteFoodsEvent {
  final String foodId;

  const AddFavoriteFood(this.foodId);

  @override
  List<Object> get props => [foodId];

  @override
  String toString() {
    return "Add favorite food $foodId";
  }
}

class DeleteFavoriteFood extends FavoriteFoodsEvent {
  final String foodId;

  const DeleteFavoriteFood(this.foodId);

  @override
  List<Object> get props => [foodId];

  @override
  String toString() {
    return "Delete favorite food $foodId";
  }
}

class FavoriteFoodsUpdated extends FavoriteFoodsEvent {
  final List<String> favoriteFoods;

  const FavoriteFoodsUpdated(this.favoriteFoods);

  @override
  List<Object> get props => [favoriteFoods];
}

class LoadFavoriteFoods extends FavoriteFoodsEvent {}