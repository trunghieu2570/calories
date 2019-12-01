import 'package:calories/models/food_model.dart';
import 'package:equatable/equatable.dart';

abstract class FoodState extends Equatable {
  const FoodState();

  @override
  List<Object> get props => [];
}

class FoodLoading extends FoodState {}

class FoodAdded extends FoodState {
  final Food food;

  const FoodAdded(this.food);

  @override
  List<Object> get props => [food];

  @override
  String toString() {
    return "FoodAdded $food";
  }
}

class FoodLoaded extends FoodState {
  final List<Food> foods;

  const FoodLoaded(this.foods);

  @override
  List<Object> get props => [foods];

  @override
  String toString() {
    return "FoodLoaded $foods";
  }
}

class FoodNotLoad extends FoodState {}
