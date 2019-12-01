import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:calories/repositories/repositories.dart';
import 'package:flutter/cupertino.dart';

import './bloc.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final FoodRepository _foodRepository;
  StreamSubscription _foodsSubscription;

  FoodBloc({@required FoodRepository foodRepository})
      : assert(foodRepository != null),
        _foodRepository = foodRepository;

  @override
  FoodState get initialState => FoodLoading();

  @override
  Stream<FoodState> mapEventToState(
    FoodEvent event,
  ) async* {
    if (event is LoadFoods) {
      yield* _mapLoadFoodsToState();
    } else if (event is AddFood) {
      yield* _mapAddFoodToState(event);
    } else if (event is DeleteFood) {
      yield* _mapDeleteFoodToState(event);
    } else if (event is UpdateFood) {
      yield* _mapUpdateFoodToState(event);
    } else if (event is FoodsUpdated) {
      yield* _mapFoodsUpdateToState(event);
    }
  }

  Stream<FoodState> _mapLoadFoodsToState() async* {
    _foodsSubscription?.cancel();
    _foodsSubscription =
        _foodRepository.getFoods().listen((foods) => add(FoodsUpdated(foods)));
  }

  Stream<FoodState> _mapAddFoodToState(AddFood event) async* {
    final newFoodId = await _foodRepository.addNewFood(event.food);
    yield FoodAdded(event.food.copyWith(id: newFoodId));
  }

  Stream<FoodState> _mapDeleteFoodToState(DeleteFood event) async* {
    _foodRepository.deleteFood(event.food);
  }

  Stream<FoodState> _mapUpdateFoodToState(UpdateFood event) async* {
    _foodRepository.updateFood(event.food);
  }

  Stream<FoodState> _mapFoodsUpdateToState(FoodsUpdated event) async* {
    yield FoodLoaded(event.foods);
  }

  @override
  Future<void> close() {
    _foodsSubscription?.cancel();
    return super.close();
  }
}
