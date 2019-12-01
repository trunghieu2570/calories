import 'package:calories/models/food_model.dart';
import 'package:equatable/equatable.dart';

abstract class FoodEvent extends Equatable {
  const FoodEvent();
  @override
  List<Object> get props => [];
}

class AddFood extends FoodEvent {
  final Food food;
  const AddFood(this.food);
  @override
  List<Object> get props => [food];
  @override
  String toString() {
    return "Add food $food";
  }
}

class DeleteFood extends FoodEvent {
  final Food food;
  const DeleteFood(this.food);
  @override
  List<Object> get props => [food];
  @override
  String toString() {
    return "Delete food $food";
  }
}

class UpdateFood extends FoodEvent {
  final Food food;
  const UpdateFood(this.food);
  @override
  List<Object> get props => [food];
  @override
  String toString() {
    return "Update food $food";
  }
}

class FoodsUpdated extends FoodEvent {
  final List<Food> foods;
  const FoodsUpdated(this.foods);
  @override
  List<Object> get props => [foods];
}

class LoadFoods extends FoodEvent {}
